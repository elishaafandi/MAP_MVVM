import 'package:flutter/material.dart';
import 'package:map_mvvm/view/viewmodel.dart';
import 'package:movease/screens/add_bicycle/add_bicycle_view.dart';
import 'package:movease/screens/add_car/add_car_view.dart';
import 'package:movease/screens/add_scooter/add_scooter_view.dart';
import 'package:movease/screens/add_motorcycle/add_motorcycle_view.dart';
import '../../services/vehicle/vehicle_service.dart';
import '../../services/auth/auth_service.dart';
import '../../models/vehicle.dart';

enum VehicleType { car, motorcycle, scooter, bicycle }

class AddVehicleViewModel extends Viewmodel {
  final VehicleService _vehicleService;
  final AuthService _authService;

  AddVehicleViewModel({
    required VehicleService vehicleService,
    required AuthService authService,
  })  : _vehicleService = vehicleService,
        _authService = authService;

  Future<void> addVehicle(String name, VehicleType type, double price) async {
    try {
      await update(() async {
        final userId = _authService.currentUser?.uid;
        if (userId == null) throw Exception('User not authenticated');
        final bool availability = true;

        final vehicle = Vehicle(
            id: '', // Firebase will generate this
            name: name,
            type: type.toString().split('.').last,
            price: price,
            userId: userId,
            availability: availability);

        await _vehicleService.addVehicle(vehicle);
      });
    } catch (e) {
      // Handle error appropriately
      turnIdle(); // Ensure we turn idle in case of error
      rethrow;
    }
  }

  void navigateToVehicleForm(BuildContext context, VehicleType type) {
    Widget targetView;
    switch (type) {
      case VehicleType.car:
        targetView = AddCarView();
        break;
      case VehicleType.scooter:
        targetView = AddScooterView();
        break;
      case VehicleType.bicycle:
        targetView = AddBicycleView();
        break;
      case VehicleType.motorcycle:
        targetView = AddMotorcycleView();
        break;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => targetView),
    );
  }
}
