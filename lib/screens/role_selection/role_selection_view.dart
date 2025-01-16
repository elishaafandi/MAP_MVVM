import 'package:flutter/material.dart';
import 'package:map_mvvm/view/view.dart';
import 'role_selection_viewmodel.dart';
import '../../models/role_card_data.dart';
import '../../models/user_role.dart';
import '../../configs/routes.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewWrapper<RoleSelectionViewModel>(
      builder: (context, viewModel) => Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.black87, Colors.black],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 32),
                  _buildHeader(),
                  const SizedBox(height: 32),
                  _buildWelcomeSection(viewModel.username),
                  const SizedBox(height: 24),
                  ...viewModel.roleCards.map((roleCard) => _buildRoleCard(
                        context,
                        roleCard,
                        viewModel.username,
                      )),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Hero(
          tag: 'logo',
          child: Image.asset('assets/images/rental.png', height: 150),
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
      ],
    );
  }

  Widget _buildWelcomeSection(String username) {
    return Column(
      children: [
        Text(
          'Welcome, $username',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Choose your user type:',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildRoleCard(
    BuildContext context,
    RoleCardData roleCard,
    String username,
  ) {
    return GestureDetector(
      onTap: () => _handleRoleSelection(context, roleCard, username),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Image.asset(
              roleCard.image,
              width: 120,
              height: 120,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    roleCard.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellow.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    roleCard.subtitle,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleRoleSelection(
    BuildContext context,
    RoleCardData roleCard,
    String username,
  ) {
    if (roleCard.role == UserRole.renter) {
      Navigator.pushNamed(
        context,
        Routes.renter,
        arguments: {'username': username},
      );
    } else if (roleCard.role == UserRole.rentee) {
      Navigator.pushNamed(
        context,
        Routes.rentee,
        arguments: {'username': username},
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('This role is not implemented yet!')),
      );
    }
  }
}
