import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_service.dart';
import '../../models/user_model.dart';

class FirebaseUserService extends UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<UserModel> getUserByEmail(String email) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return UserModel.fromMap(querySnapshot.docs.first.data());
      }
      throw Exception('User not found');
    } catch (e) {
      print('Error getting user: $e');
      throw Exception('Failed to get user: $e');
    }
  }

  @override
  Future<void> updateUser(String email, UserModel user) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await _firestore
            .collection('users')
            .doc(querySnapshot.docs.first.id)
            .update(user.toMap());
      } else {
        throw Exception('User not found for update');
      }
    } catch (e) {
      print('Error updating user: $e');
      throw Exception('Failed to update user: $e');
    }
  }

  @override
  Stream<UserModel?> getUserStream(String email) {
    return _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return UserModel.fromMap(snapshot.docs.first.data());
      }
      throw Exception('User not found in stream');
    });
  }
}
