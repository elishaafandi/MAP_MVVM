import 'package:flutter/material.dart';
import 'package:map_mvvm/view/view.dart';
import 'add_vehicle_viewmodel.dart';
//import 'add_vehicle_form_view.dart';

class AddVehiclePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewWrapper<AddVehicleViewModel>(
      builder: (context, viewmodel) => Scaffold(
        appBar: AppBar(
          title: Text('Add Vehicle'),
          backgroundColor: Colors.teal.shade600,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildVehicleCard(
                context,
                'Car',
                Icons.directions_car,
                () => viewmodel.navigateToVehicleForm(context, VehicleType.car),
              ),
              _buildVehicleCard(
                context,
                'Motorcycle',
                Icons.motorcycle,
                () => viewmodel.navigateToVehicleForm(
                    context, VehicleType.motorcycle),
              ),
              _buildVehicleCard(
                context,
                'Scooter',
                Icons.electric_scooter,
                () => viewmodel.navigateToVehicleForm(
                    context, VehicleType.scooter),
              ),
              _buildVehicleCard(
                context,
                'Bicycle',
                Icons.pedal_bike,
                () => viewmodel.navigateToVehicleForm(
                    context, VehicleType.bicycle),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.teal.shade600),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
