import 'package:flutter/material.dart';
import 'package:map_mvvm/view/view.dart';

import 'renter_viewmodel.dart';
import 'constants.dart';

class RenterBottomNav extends StatelessWidget {
  const RenterBottomNav({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewWrapper<RenterViewModel>(
      builder: (_, viewmodel) => Container(
        decoration: BoxDecoration(
          color: cardGrey,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: cardGrey,
          selectedItemColor: primaryYellow,
          unselectedItemColor: textGrey,
          currentIndex: viewmodel.selectedIndex,
           onTap: (index) => viewmodel.onNavigate(context, index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.view_list),
              label: 'View Rentals',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt),
              label: 'Rental Status',
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
