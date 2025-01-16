import 'package:flutter/material.dart';
import 'package:map_mvvm/view/viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/booking_with_details.dart';
import '../../services/booking/booking_service.dart';

class BookingListViewModel extends Viewmodel {
  final BookingService _bookingService;
 
  final FirebaseAuth _auth;

  BookingListViewModel({
    required BookingService bookingService,
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _bookingService = bookingService,
        _auth = auth ?? FirebaseAuth.instance;

  Stream<List<BookingWithDetails>> get bookingsStream {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _bookingService
        .getBookingsStreamForUser(user.uid)
        .map((bookings) => bookings..sort(_compareBookingStatus));
  }

  int _compareBookingStatus(BookingWithDetails a, BookingWithDetails b) {
    final statusPriority = {
      'pending': 0,
      'approved': 1,
      'rejected': 2,
    };
    final statusA = (a.status).toLowerCase();
    final statusB = (b.status).toLowerCase();
    return (statusPriority[statusA] ?? 3)
        .compareTo(statusPriority[statusB] ?? 3);
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green[400]!;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String getStatusEmoji(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return '✅';
      case 'pending':
        return '⏳';
      case 'rejected':
        return '❌';
      default:
        return '📋';
    }
  }

  Future<void> approveBooking(BuildContext context, String bookingId) async {
    try {
      await _bookingService.updateBookingStatus(
        bookingId,
        'approved',
        'booking confirmed',
        'booking confirmed',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking approved successfully'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update booking status'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
