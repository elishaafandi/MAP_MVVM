import 'package:flutter/material.dart';
import 'package:map_mvvm/view/view.dart';
import 'registration_viewmodel.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _matricNoController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  Future<void> _handleRegister(RegistrationViewModel viewModel) async {
    if (viewModel.areFieldsEmpty(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      username: _usernameController.text.trim(),
      matricNo: _matricNoController.text.trim(),
      course: _courseController.text.trim(),
      address: _addressController.text.trim(),
    )) {
      viewModel.showError(context, 'Please fill in all fields.');
      return;
    }

    try {
      // Prepare additional data for the user
      final additionalData = {
        'username': _usernameController.text.trim(),
        'matricNo': _matricNoController.text.trim(),
        'course': _courseController.text.trim(),
        'address': _addressController.text.trim(),
      };

      // Call the registerUser method
      await viewModel.registerUser(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        additionalData,
      );

      viewModel.showSuccess(context, 'Registration successful!');
      Navigator.pop(context);
    } catch (error) {
      viewModel.showError(context, 'An error occurred: $error');
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.yellow.shade700),
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
    return ViewWrapper<RegistrationViewModel>(
      builder: (_, viewModel) => Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black87, Colors.black],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                      "CREATE ACCOUNT",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow.shade700,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildTextField(
                        controller: _usernameController,
                        label: 'Full Name',
                        icon: Icons.person),
                    const SizedBox(height: 16),
                    _buildTextField(
                        controller: _emailController,
                        label: 'Email Address',
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 16),
                    _buildTextField(
                        controller: _passwordController,
                        label: 'Password',
                        icon: Icons.lock,
                        obscureText: true),
                    const SizedBox(height: 16),
                    _buildTextField(
                        controller: _matricNoController,
                        label: 'Matric Number',
                        icon: Icons.assignment),
                    const SizedBox(height: 16),
                    _buildTextField(
                        controller: _courseController,
                        label: 'Course',
                        icon: Icons.school),
                    const SizedBox(height: 16),
                    _buildTextField(
                        controller: _addressController,
                        label: 'Address',
                        icon: Icons.location_on),
                    const SizedBox(height: 20),
                    viewModel.isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.yellow.shade700),
                            ),
                          )
                        : ElevatedButton(
                            onPressed: viewModel.isLoading
                                ? null
                                : () => _handleRegister(
                                    viewModel), // Correct method name
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow.shade700,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 32.0),
                            ),
                            child: viewModel.isLoading
                                ? CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.black),
                                  )
                                : const Text('Sign Up'),
                          ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Already have an account? Log In'),
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
