import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:map_mvvm/view/viewmodel.dart';
import 'package:movease/screens/notification_rentee/notification_rentee_view.dart';
import 'package:movease/screens/booking_list/booking_list_view.dart';
import 'package:movease/screens/booking_status_rentee/booking_status_rentee_view.dart';
import '../../models/vehicle.dart';
import '../../services/vehicle/vehicle_service.dart';
import '../../services/auth/auth_service.dart';

class RenteeViewModel extends Viewmodel {
  final VehicleService _vehicleService;
  final AuthService _authService;
  List<Vehicle> _vehicles = [];
  List<Vehicle> _filteredVehicles = [];
  int _selectedIndex = 0;

  RenteeViewModel({
    required VehicleService vehicleService,
    required AuthService authService,
  })  : _vehicleService = vehicleService,
        _authService = authService;

  List<Vehicle> get vehicles => _filteredVehicles;
  int get selectedIndex => _selectedIndex;
  bool get isLoading => busy;

  @override
  void init() {
    super.init();
    fetchVehicles();
  }

  Future<void> fetchVehicles() async {
    await update(() async {
      _vehicles = await _vehicleService.fetchVehicles();
      _filteredVehicles = _vehicles;
    });
  }

  void filterVehicles(String query) {
    _filteredVehicles = _vehicles
        .where((vehicle) =>
            vehicle.name.toLowerCase().contains(query.toLowerCase()) ||
            vehicle.type.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  Future<void> signOut() async {
    await _authService.signOut();
    await FirebaseFirestore.instance.terminate();
  }

  void onNavItemTapped(int index, BuildContext context) {
    _selectedIndex = index;
    notifyListeners();

    switch (index) {
      case 1: // Bookings tab
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingListView(),
          ),
        );
      case 2: // Bookings tab
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingStatusRenteeView(),
          ),
        );
        break;
      case 4: // Notifications tab
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NotificationsPage(),
          ),
        );
        break;
      // ... handle other cases
    }
  }
}
