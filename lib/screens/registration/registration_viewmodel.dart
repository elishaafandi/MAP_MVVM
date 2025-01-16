import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:map_mvvm/view/viewmodel.dart';

class RegistrationViewModel extends Viewmodel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Validate if any field is empty.
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

  void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(message, style: const TextStyle(color: Colors.red))),
    );
  }

  /// Display a success message.
  void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(message, style: const TextStyle(color: Colors.green))),
    );
  }

  /// Registers a new user and stores their data in Firestore.
  Future<void> registerUser(
    String email,
    String password,
    Map<String, dynamic> additionalData,
  ) async {
    // Use the `update` method to manage the busy state automatically.
    await update(() async {
      try {
        final UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final userId = await _getNextUserId();

        // Save user details in Firestore.
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          ...additionalData,
          'userId': userId,
          'email': email,
          'createdAt': DateTime.now(),
        });
      } catch (e) {
        debugPrint("Error registering user: $e");
        rethrow; // Rethrow to handle errors in the UI layer if needed.
      }
    });
  }

  /// Retrieves the next unique user ID from a counter in Firestore.
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
    // Perform any initialization tasks specific to RegistrationViewModel here.
    super.init();
  }
}
