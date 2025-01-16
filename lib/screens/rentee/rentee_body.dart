// rentee_body.dart
import 'package:flutter/material.dart';
import 'package:map_mvvm/view/view.dart';
import 'rentee_viewmodel.dart';
import 'vehicle_grid.dart';

class RenteeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewWrapper<RenteeViewModel>(
      builder: (context, viewModel) => SingleChildScrollView(
        child: Column(
          children: [
            _buildBanner(context),
            _buildCategories(),
            VehicleGrid(
              vehicles: viewModel.vehicles,
              isLoading: viewModel.isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner(BuildContext context) {
    return Container(
      height: 150,
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.yellow[700]!, Color(0xFF1E1E1E)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Share your Ride, Earn on the Side!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/renter');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    "Start Now!",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildCategoryChip("All", true),
          _buildCategoryChip("Car", false),
          _buildCategoryChip("Motorcycle", false),
          _buildCategoryChip("Scooter", false),
          _buildCategoryChip("Bicycle", false),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: isSelected ? Colors.yellow[700] : Color(0xFF2A2A2A),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}
