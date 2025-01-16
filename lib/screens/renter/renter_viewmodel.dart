import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:map_mvvm/view/viewmodel.dart';
import 'package:movease/models/vehicle.dart';
import 'package:movease/screens/add_vehicle/add_vehicle_view.dart';
import 'package:movease/screens/booking_request/booking_request_view.dart';
import 'package:movease/screens/booking_status_renter/booking_status_renter_viewmodel.dart';
import 'package:movease/screens/renter_feedback/renter_feedback_view.dart';
import 'package:movease/services/auth/auth_service.dart';
import 'package:movease/services/vehicle/vehicle_service.dart';

class RenterViewModel extends Viewmodel {
  final VehicleService _vehicleService;
  final AuthService _authService;
  List<Vehicle> _vehicles = [];
  int _selectedIndex = 0;
  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<QuerySnapshot>? _vehiclesSubscription;

  int get selectedIndex => _selectedIndex;
  List<Vehicle> get vehicles => _vehicles;

  RenterViewModel({
    required VehicleService vehicleService,
    required AuthService authService,
  })  : _vehicleService = vehicleService,
        _authService = authService;

  @override
  void init() {
    super.init();
    // Set up auth state listener
    _authSubscription = _authService.authStateChanges.listen((User? user) {
      if (user != null) {
        // When auth state changes, set up the vehicles stream
        _setupVehiclesStream(user.uid);
      } else {
        // Clear vehicles when logged out
        _vehicles = [];
        _vehiclesSubscription?.cancel();
        notifyListeners();
      }
    });

    // Initial fetch for current user
    final currentUser = _authService.currentUser;
    if (currentUser != null) {
      _setupVehiclesStream(currentUser.uid);
    }
  }

  void _setupVehiclesStream(String userId) {
    // Cancel existing subscription if any
    _vehiclesSubscription?.cancel();

    // Set up new subscription
    _vehiclesSubscription = FirebaseFirestore.instance
        .collection('vehicles')
        .where('user_id', isEqualTo: userId)
        .snapshots()
        .listen((snapshot) {
      _vehicles = snapshot.docs
          .map((doc) => Vehicle.fromMap(doc.id, doc.data()))
          .toList();
      notifyListeners();
    });
  }

  Future<void> toggleVehicleAvailability(
      String vehicleId, bool newValue) async {
    try {
      await update(() async {
        // Find the vehicle index
        final vehicleIndex = _vehicles.indexWhere((v) => v.id == vehicleId);
        if (vehicleIndex == -1) return;

        // Update Firestore
        await FirebaseFirestore.instance
            .collection('vehicles')
            .doc(vehicleId)
            .update({
          'availability': newValue,
          'lastUpdated': FieldValue.serverTimestamp(),
        });

        // The stream will handle updating the UI
      });
    } catch (error) {
      print('Error updating availability: $error');
      // Optionally show error message
    }
  }

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  Future<void> deleteVehicle(String vehicleId) async {
    await update(() async {
      await _vehicleService.deleteVehicle(vehicleId);
      // No need to manually fetch vehicles as the stream will update automatically
    });
  }

  Future<void> signOut() async {
    await _authService.signOut();
    await FirebaseFirestore.instance.terminate();
  }

  void navigateToAddVehicle(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddVehiclePage()),
    );
  }

  void onNavigate(BuildContext context, int index) {
    _selectedIndex = index;
    notifyListeners();

    switch (index) {
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => BookingRequestView()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => BookingStatusRenterView()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => RenterFeedbackView()),
        );
        break;
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _vehiclesSubscription?.cancel();
    super.dispose();
  }
}
