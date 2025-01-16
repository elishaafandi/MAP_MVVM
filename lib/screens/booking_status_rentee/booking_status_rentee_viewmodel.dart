import 'package:flutter/material.dart';
import 'package:map_mvvm/view/viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingStatusRenteeViewModel extends Viewmodel {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  
  List<Map<String, dynamic>> bookings = [];
  String? error;

  BookingStatusRenteeViewModel({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  @override
  void init() {
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    await update(() async {
      try {
        bookings = await _fetchBookingsData();
      } catch (e) {
        error = 'Error fetching bookings: $e';
        print(error);
      }
    });
  }

  Future<List<Map<String, dynamic>>> _fetchBookingsData() async {
    final user = _auth.currentUser;
    if (user == null) return [];

    try {
      final bookingsQuery = await _firestore
          .collection('bookings')
          .where('renterId', isEqualTo: user.uid)
          .where('booking_status', isEqualTo: 'approved')
          .get();

      if (bookingsQuery.docs.isEmpty) return [];

      List<Map<String, dynamic>> bookingsWithDetails = [];

      for (var bookingDoc in bookingsQuery.docs) {
        final bookingData = bookingDoc.data();
        final vehicleId = bookingData['vehicleId'];
        final vehicleDetails = await _fetchVehicleDetails(vehicleId);

        if (vehicleDetails != null) {
          bookingsWithDetails.add({
            ...bookingData,
            'bookingId': bookingDoc.id,
            'vehicleName': _getVehicleName(vehicleDetails),
            'vehicleType': vehicleDetails['vehicle_type'] ?? 'Unknown Type',
            'vehicleDetails': vehicleDetails,
          });
        }
      }

      return bookingsWithDetails;
    } catch (e) {
      print('Error fetching bookings: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> _fetchVehicleDetails(String vehicleId) async {
    try {
      final vehicleDoc = await _firestore
          .collection('vehicles')
          .doc(vehicleId)
          .get();

      if (vehicleDoc.exists) {
        final data = vehicleDoc.data()!;
        return {
          'name': data['vehicle_name'] ?? 'Unknown Vehicle',
          'plateNo': data['plate_number'] ?? 'No Plate',
          'pricePerHour': data['price_per_hour'] ?? 0.0,
          ...data
        };
      }
      return null;
    } catch (e) {
      print('Error fetching vehicle details: $e');
      return null;
    }
  }

  String _getVehicleName(Map<String, dynamic> vehicleDetails) {
    return vehicleDetails['vehicle_name'] ?? 'Unnamed Vehicle';
  }

  Color getCurrentStatusColor(String currentStatus) {
    switch (currentStatus.toLowerCase()) {
      case 'booking confirmed':
        return Colors.green[400]!;
      case 'deposit required':
        return Colors.purple;
      case 'deposit paid':
        return Colors.blue;
      case 'car delivery':
        return Colors.indigo;
      case 'pre-inspection required':
        return Colors.cyan;
      case 'pre-inspection completed':
        return Colors.teal;
      case 'vehicle usage':
        return Colors.green;
      case 'return pending':
        return Colors.amber;
      case 'final payment required':
        return Colors.deepOrange;
      case 'completed':
        return Colors.yellow[700]!;
      case 'rated':
        return Colors.green[700]!;
      default:
        return Colors.grey;
    }
  }

  String getCurrentStatusEmoji(String currentStatus) {
    switch (currentStatus.toLowerCase()) {
      case 'booking confirmed':
        return '✅';
      case 'deposit required':
        return '💰';
      case 'deposit paid':
        return '✨';
      case 'car delivery':
        return '🚗';
      case 'pre-inspection required':
        return '🔍';
      case 'pre-inspection completed':
        return '📝';
      case 'vehicle usage':
        return '🚘';
      case 'return pending':
        return '↩️';
      case 'final payment required':
        return '💳';
      case 'completed':
        return '🎉';
      case 'rated':
        return '⭐';
      default:
        return '📋';
    }
  }
}