import 'package:map_mvvm/view/viewmodel.dart';
import '../../services/auth/auth_service.dart';
import '../../models/auth/login_credentials.dart';
import '../../models/user_model.dart';
import '../../configs/service_locator.dart';

class LoginViewModel extends Viewmodel {
  final AuthService _authService = locator<AuthService>();  // Correctly accessing AuthService from the locator
  bool isLoading = false;
  bool isPasswordVisible = false;
  UserModel? currentUser;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    update();
  }

  void setLoading(bool value) {
    isLoading = value;
    update();
  }

  Future<UserModel> loginUser(String email, String password) async {
    setLoading(true);
    try {
      final credentials = LoginCredentials(email: email, password: password);
      if (!credentials.isValid()) {
        throw Exception('Invalid credentials');
      }

      currentUser = await _authService.signInWithEmailAndPassword(email, password);
      return currentUser!;
    } finally {
      setLoading(false);
    }
  }
}
