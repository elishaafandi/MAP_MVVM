import 'package:flutter/material.dart';
import 'package:map_mvvm/view/viewmodel.dart';
import 'package:movease/screens/submit_booking/submission_success_view.dart';
import '../../services/booking/booking_service.dart';
import '../../services/vehicle/vehicle_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SubmitBookingViewModel extends Viewmodel {
  final VehicleService _vehicleService;

  bool _isLoading = true;
  bool _isLoaded = false;
  Map<String, dynamic> _vehicleDetails = {};
  Map<String, dynamic> _userDetails = {};

  bool get isLoading => _isLoading;
  bool get isLoaded => _isLoaded;

  SubmitBookingViewModel({
    required VehicleService vehicleService,
    required BookingService bookingService,
  }) : _vehicleService = vehicleService;

  List<Map<String, dynamic>> get vehicleDetailsList => [
        {'label': 'Brand', 'value': _vehicleDetails['vehicle_brand'] ?? ''},
        {'label': 'Model', 'value': _vehicleDetails['vehicle_model'] ?? ''},
        {
          'label': 'Plate Number',
          'value': _vehicleDetails['plate_number'] ?? ''
        },
        {
          'label': 'Transmission',
          'value': _vehicleDetails['transmission_type'] ?? ''
        },
      ];

  List<Map<String, dynamic>> get userDetailsList => [
        {'label': 'Name', 'value': _userDetails['username'] ?? ''},
        {'label': 'Matric No', 'value': _userDetails['matricNo'] ?? ''},
        {'label': 'Course', 'value': _userDetails['course'] ?? ''},
      ];

  List<Map<String, dynamic>> getBookingDetailsList(
          Map<String, String> bookingDetails) =>
      [
        {'label': 'Location', 'value': bookingDetails['location'] ?? ''},
        {
          'label': 'Pickup',
          'value':
              '${bookingDetails['pickupDate']} at ${bookingDetails['pickupTime']}'
        },
        {
          'label': 'Return',
          'value':
              '${bookingDetails['returnDate']} at ${bookingDetails['returnTime']}'
        },
      ];

  Future<void> loadData(String vehicleId) async {
    try {
      _isLoading = true;
      notifyListeners();

      final vehicleData = await _vehicleService.getVehicleDetails(vehicleId);
      _vehicleDetails = vehicleData;

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        _userDetails = userDoc.data() ?? {};
      }

      _isLoaded = true;
    } catch (e) {
      print('Error loading data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitBooking(
    BuildContext context,
    String vehicleId,
    Map<String, String> bookingDetails,
  ) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _showError(context, 'User not logged in');
        return;
      }

      final vehicleDoc = await FirebaseFirestore.instance
          .collection('vehicles')
          .doc(vehicleId)
          .get();

      if (!vehicleDoc.exists) {
        _showError(context, 'Vehicle not found');
        return;
      }

      final renterId = vehicleDoc.data()?['user_id'];
      if (renterId == null) {
        _showError(context, 'Vehicle owner information not found');
        return;
      }

      await FirebaseFirestore.instance.collection('bookings').add({
        'renteeId': user.uid,
        'renterId': renterId,
        'vehicleId': vehicleId,
        'location': bookingDetails['location'],
        'pickupDate': bookingDetails['pickupDate'],
        'pickupTime': bookingDetails['pickupTime'],
        'returnDate': bookingDetails['returnDate'],
        'returnTime': bookingDetails['returnTime'],
        'booking_status': 'pending',
        'renteeStatus': 'not processed',
        'renterStatus': 'not processed',
        'createdAt': Timestamp.now(),
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SubmissionSuccessView()),
      );
    } catch (e) {
      _showError(context, e.toString());
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
