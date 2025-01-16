// rentee_drawer.dart
import 'package:flutter/material.dart';
import 'package:map_mvvm/view/view.dart';
import 'rentee_viewmodel.dart';

class RenteeDrawer extends StatelessWidget {
  final String username;

  const RenteeDrawer({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewWrapper<RenteeViewModel>(
      builder: (context, viewModel) => Drawer(
        child: Container(
          color: Color(0xFF1E1E1E),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.yellow[700],
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ),
              _buildDrawerItem(
                Icons.home,
                'Home',
                () {
                  Navigator.pop(context);
                  viewModel.setSelectedIndex(0);
                },
              ),
              _buildDrawerItem(
                Icons.receipt,
                'Booking Status',
                () {
                  Navigator.pop(context);
                  viewModel.setSelectedIndex(1);
                },
              ),
              _buildDrawerItem(
                Icons.feedback,
                'Feedback',
                () {
                  Navigator.pop(context);
                  viewModel.setSelectedIndex(2);
                },
              ),
              _buildDrawerItem(
                Icons.logout,
                'Logout',
                () async {
                  await viewModel.signOut();
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[400]),
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      onTap: onTap,
    );
  }
}
