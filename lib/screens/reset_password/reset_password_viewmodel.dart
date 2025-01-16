import 'package:map_mvvm/view/viewmodel.dart';
import '../../configs/service_locator.dart';
import '../../services/auth/auth_service.dart';

class ResetPasswordViewmodel extends Viewmodel {
  final AuthService _authService = locator<AuthService>();
  bool _isLoading = false;
  String _email = '';
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String get email => _email;
  String? get errorMessage => _errorMessage;

  void setEmail(String value) {
    _email = value;
    update();
  }

  Future<bool> resetPassword() async {
    if (_email.trim().isEmpty) {
      _errorMessage = 'Please enter your email address';
      update();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    update();

    try {
      await _authService.sendPasswordResetEmail(_email.trim());
      _isLoading = false;
      update();
      return true;
    } catch (e) {
      _isLoading = false;
      if (e.toString().contains('user-not-found')) {
        _errorMessage = 'No user found for that email.';
      } else {
        _errorMessage = 'An error occurred while resetting password';
      }
      update();
      return false;
    }
  }
}