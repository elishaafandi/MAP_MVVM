import 'package:flutter/material.dart';
import 'package:map_mvvm/view/view.dart';
import 'renter_viewmodel.dart';
import 'constants.dart';

class RenterDrawer extends StatelessWidget {
  final String username;

  const RenterDrawer({
    Key? key,
    required this.username,
  }) : super(key: key);

  Widget _buildDrawerItem(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: primaryYellow),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      onTap: onTap ?? () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewWrapper<RenterViewModel>(
      builder: (context, viewmodel) => Drawer(
        child: Container(
          color: cardGrey,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: backgroundBlack,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: primaryYellow,
                      child:
                          Icon(Icons.person, size: 40, color: backgroundBlack),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Hello, $username',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              _buildDrawerItem(Icons.history, 'View Rental History'),
              _buildDrawerItem(Icons.directions_car, 'View All Vehicles'),
              _buildDrawerItem(
                Icons.logout,
                'Logout',
                onTap: () async {
                  await viewmodel.signOut();
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
}
