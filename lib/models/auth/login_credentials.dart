// TODO Implement this library.
class LoginCredentials {
  final String email;
  final String password;

  LoginCredentials({
    required this.email,
    required this.password,
  });

  bool isValid() {
    return email.isNotEmpty && password.isNotEmpty;
  }
}
