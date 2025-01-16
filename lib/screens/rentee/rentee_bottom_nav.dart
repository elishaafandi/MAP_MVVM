// rentee_bottom_nav.dart
import 'package:flutter/material.dart';
import 'package:map_mvvm/view/view.dart';
import 'rentee_viewmodel.dart';

class RenteeBottomNav extends StatelessWidget {
  const RenteeBottomNav({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewWrapper<RenteeViewModel>(
      builder: (_, viewModel) => Container(
        decoration: BoxDecoration(
          color: Color(0xFF1E1E1E),
          border: Border(
            top: BorderSide(color: Colors.grey[900]!, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color(0xFF1E1E1E),
          selectedItemColor: Colors.yellow[700],
          unselectedItemColor: Colors.grey[600],
          currentIndex: viewModel.selectedIndex,
          onTap: (index) => viewModel.onNavItemTapped(index, context),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt),
              label: 'Bookings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: 'Status',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.feedback),
              label: 'Feedback',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
