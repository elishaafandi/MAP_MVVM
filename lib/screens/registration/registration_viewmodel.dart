// lib/screens/registration/registration_viewmodel.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:map_mvvm/view/viewmodel.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

class RegistrationViewModel extends Viewmodel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();
  String? _base64Image;
  String? get base64Image => _base64Image;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        _base64Image = base64Encode(bytes);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      rethrow;
    }
  }

  bool areFieldsEmpty({
    required String email,
    required String password,
    required String username,
    required String matricNo,
    required String course,
    required String address,
  }) {
    return email.isEmpty ||
        password.isEmpty ||
        username.isEmpty ||
        matricNo.isEmpty ||
        course.isEmpty ||
        address.isEmpty;
  }

  void showMessage(BuildContext context, String message, bool isError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> registerUser(
    String email,
    String password,
    Map<String, dynamic> additionalData,
  ) async {
    _setLoading(true);
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userId = await _getNextUserId();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        ...additionalData,
        'userId': userId,
        'email': email,
        'profilePhoto': _base64Image ?? '',
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      debugPrint("Error registering user: $e");
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<int> _getNextUserId() async {
    final counterRef =
        FirebaseFirestore.instance.collection('counters').doc('userIdCounter');

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(counterRef);
      if (!snapshot.exists) {
        transaction.set(counterRef, {'currentId': 1});
        return 1;
      }

      final currentId = snapshot['currentId'] as int;
      final nextId = currentId + 1;
      transaction.update(counterRef, {'currentId': nextId});
      return nextId;
    });
  }

  @override
  void init() {
    super.init();
  }
}