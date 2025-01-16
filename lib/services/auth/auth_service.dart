import 'package:firebase_auth/firebase_auth.dart';
import '../../models/user_model.dart';


abstract class AuthService {
  User? get currentUser;
  Future<UserModel> signInWithEmailAndPassword(String email, String password);
  Future<void> sendPasswordResetEmail(String email);
  Future<UserCredential> registerUser(String email, String password);
  Future<int> getNextUserId();
  Future<void> signOut();
  Stream<User?> get authStateChanges;
}
