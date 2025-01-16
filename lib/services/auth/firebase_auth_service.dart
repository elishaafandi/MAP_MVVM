import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/user_model.dart';
import 'auth_service.dart';

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  User? get currentUser => _auth.currentUser;

  @override
  Future<UserModel> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      

      if (userCredential.user != null) {
        // Fetch user data from Firestore
       final querySnapshot = await _firestore
            .collection('users')
            .where('email', isEqualTo: email)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final userData = querySnapshot.docs.first.data();
          return UserModel.fromMap(userData);
        }
      }
      throw Exception('Failed to sign in: User data not found');
    } catch (e) {
      print('Sign in error: $e');
      throw Exception('Failed to sign in: $e');
    }
  }
    /*final firebaseUser = userCredential.user!;
    return UserModel(
      username: userDoc.exists ? userDoc.get('username') : '',
      email: firebaseUser.email ?? '',
      password: credentials.password,
      matricNo: '',
      course: '',
      address: '',
      createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
    );*/
  

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<UserCredential> registerUser(String email, String password) async {
    UserCredential credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await _firestore.collection('users').doc(email).set({
      'username': email.split('@')[0],
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return credential;
  }

  @override
  Future<int> getNextUserId() async {
    final counterRef = _firestore.collection('counters').doc('userIdCounter');
    return _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(counterRef);
      if (!snapshot.exists) {
        transaction.set(counterRef, {'currentId': 1});
        return 1;
      }
      final currentId = snapshot['currentId'] as int;
      transaction.update(counterRef, {'currentId': currentId + 1});
      return currentId + 1;
    });
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

   @override
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
