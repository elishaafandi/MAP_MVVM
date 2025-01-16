import 'package:flutter/material.dart';
import 'renter_app_bar.dart';
import 'renter_body.dart';
import 'renter_drawer.dart';
import 'renter_bottom_nav.dart';
import 'constants.dart';

class RenterPage extends StatelessWidget {
  final String username;

  const RenterPage({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundBlack,
      appBar: RenterAppBar(username: username),
      drawer: RenterDrawer(username: username),
      body: const RenterBody(),
      bottomNavigationBar: const RenterBottomNav(),
    );
  }
}
