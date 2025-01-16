import 'package:flutter/material.dart';
import 'package:map_mvvm/view/view.dart';
import 'renter_viewmodel.dart';
import 'constants.dart';

class RenterAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String username;

  const RenterAppBar({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return ViewWrapper<RenterViewModel>(
      builder: (context, viewmodel) => AppBar(
        title: Text(
          'Welcome, $username',
          style: const TextStyle(color: primaryYellow),
        ),
        centerTitle: true,
        backgroundColor: cardGrey,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: primaryYellow),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: primaryYellow),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
