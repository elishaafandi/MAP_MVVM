import 'package:flutter/material.dart';
import 'package:map_mvvm/view/view.dart';
import 'reset_password_viewmodel.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewWrapper<ResetPasswordViewmodel>(
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
                    Hero(
                      tag: 'logo',
                      child: Image.asset(
                        'assets/images/rental.png',
                        height: 150,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'RESET PASSWORD',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow.shade700,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildTextField(
                      onChanged: viewmodel.setEmail,
                      labelText: 'Email',
                      prefixIcon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    if (viewmodel.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          viewmodel.errorMessage!,
                          style: TextStyle(
                            color: Colors.red.shade400,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    viewmodel.isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.yellow.shade700),
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              if (await viewmodel.resetPassword()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Password reset email sent. Please check your inbox.'),
                                    backgroundColor: Colors.yellow.shade700,
                                  ),
                                );
                                Navigator.pop(context);
                              }
                            },
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
                              'Send Reset Link',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Remember your password? ',
                          style: TextStyle(color: Colors.white70),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Login',
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

  Widget _buildTextField({
    required void Function(String) onChanged,
    required String labelText,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      onChanged: onChanged,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(prefixIcon, color: Colors.yellow.shade700),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
