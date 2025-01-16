import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> registerUser(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  Future<void> saveUserDetails(
      String uid, Map<String, dynamic> userDetails) async {
    await _firestore.collection('users').doc(uid).set(userDetails);
  }

  Future<int> getNextUserId() async {
    final DocumentReference counterRef =
        _firestore.collection('counters').doc('userIdCounter');

    return _firestore.runTransaction((transaction) async {
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
}
