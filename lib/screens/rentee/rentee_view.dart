import 'package:flutter/material.dart';
import 'package:map_mvvm/view/view.dart';
import 'rentee_viewmodel.dart';
import 'rentee_app_bar.dart';
import 'rentee_body.dart';
import 'rentee_drawer.dart';
import 'rentee_bottom_nav.dart';

class RenteePage extends StatefulWidget {
  final String username;

  const RenteePage({Key? key, required this.username}) : super(key: key);

  @override
  _RenteePageState createState() => _RenteePageState();
}

class _RenteePageState extends State<RenteePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewWrapper<RenteeViewModel>(
      builder: (context, viewModel) => Scaffold(
        backgroundColor: Color(0xFF121212),
        appBar: RenteeAppBar(searchController: _searchController),
        drawer: RenteeDrawer(username: widget.username),
        body: RenteeBody(),
        bottomNavigationBar: RenteeBottomNav(),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
