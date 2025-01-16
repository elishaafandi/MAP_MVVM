import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:map_mvvm/view/view.dart';
import 'login_viewmodel.dart';
import '../role_selection/role_selection_view.dart';
import 'package:movease/screens/reset_password/reset_password_view.dart';
import 'package:movease/screens/registration/registration_view.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _handleLogin(LoginViewModel viewmodel) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      _showError('Please enter both email and password');
      return;
    }

    try {
      await viewmodel.loginUser(email, password);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RoleSelectionPage()),
      );
    } on FirebaseAuthException catch (e) {
      _showError(_getErrorMessage(e));
    }
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      default:
        return 'An error occurred: ${e.message}';
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.yellow.shade700,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(prefixIcon, color: Colors.yellow.shade700),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewWrapper<LoginViewModel>(
      builder: (context, viewmodel) => Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.black87, Colors.black],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo and Title
                    Hero(
                      tag: 'logo',
                      child:
                          Image.asset('assets/images/rental.png', height: 150),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'MOVEASE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow.shade700,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      'UTM Transport Rental App',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Login Form
                    _buildTextField(
                      controller: _emailController,
                      labelText: 'Email',
                      prefixIcon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _passwordController,
                      labelText: 'Password',
                      prefixIcon: Icons.lock,
                      obscureText: !viewmodel.isPasswordVisible,
                      suffixIcon: IconButton(
                        icon: Icon(
                          viewmodel.isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.yellow.shade700,
                        ),
                        onPressed: viewmodel.togglePasswordVisibility,
                      ),
                    ),

                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResetPasswordScreen()),
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.yellow.shade700,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),

                    // Login Button
                    viewmodel.isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.yellow.shade700),
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () => _handleLogin(viewmodel),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow.shade700,
                              foregroundColor: Colors.black87,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 50,
                                vertical: 15,
                              ),
                              elevation: 5,
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),

                    const SizedBox(height: 16),

                    // Create Account Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account? ',
                          style: TextStyle(color: Colors.white70),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const RegistrationScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Create an Account',
                            style: TextStyle(
                              color: Colors.yellow.shade700,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
