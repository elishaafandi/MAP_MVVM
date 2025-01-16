import '../../models/user_model.dart';


  abstract class UserService {
  Future<UserModel> getUserByEmail(String email);
  Future<void> updateUser(String email, UserModel user);
  Stream<UserModel?> getUserStream(String email);
}

