// rentee_app_bar.dart
import 'package:flutter/material.dart';
import 'package:map_mvvm/view/view.dart';
import 'rentee_viewmodel.dart';

class RenteeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController searchController;

  const RenteeAppBar({
    Key? key,
    required this.searchController,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return ViewWrapper<RenteeViewModel>(
      builder: (context, viewModel) => AppBar(
        backgroundColor: Color(0xFF1E1E1E),
        elevation: 0,
        centerTitle: true,
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: searchController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Search for vehicles",
              hintStyle: TextStyle(color: Colors.grey[400]),
              border: InputBorder.none,
              icon: Icon(Icons.search, color: Colors.grey[400]),
            ),
            onChanged: viewModel.filterVehicles,
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.yellow[700]),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person, color: Colors.yellow[700]),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
