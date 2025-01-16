import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movease/services/booking/booking_service.dart';
import 'package:movease/models/booking_model.dart';
import 'package:movease/models/booking_with_details.dart';

class FirebaseBookingService implements BookingService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FirebaseBookingService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth, // Add this parameter
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance; // Initialize _auth

  @override
  Future<void> createBooking(BookingModel booking) async {
    try {
      await _firestore.collection('bookings').add(booking.toMap());
    } catch (e) {
      throw Exception('Failed to create booking: $e');
    }
  }

  @override
  Future<List<BookingModel>> getBookingsForUser(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('bookings')
          .where('userId', isEqualTo: userId)
          .get();

      return querySnapshot.docs
          .map((doc) => BookingModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch bookings: $e');
    }
  }

  @override
  Future<List<BookingModel?>> getBooking(String bookingId) async {
    try {
      final docSnapshot =
          await _firestore.collection('bookings').doc(bookingId).get();

      if (!docSnapshot.exists) return [null];

      return [BookingModel.fromMap(docSnapshot.data()!)];
    } catch (e) {
      throw Exception('Failed to fetch booking: $e');
    }
  }

  @override
  Stream<List<BookingWithDetails>> getBookingsStreamForUser(String userId) {
    return _firestore
        .collection('bookings')
        .where('renteeId', isEqualTo: userId)
        .snapshots()
        .asyncMap((snapshot) async {
      final bookings = <BookingWithDetails>[];

      for (var doc in snapshot.docs) {
        final bookingData = doc.data();
        final vehicleId = bookingData['vehicleId'];

        try {
          final vehicleDoc =
              await _firestore.collection('vehicles').doc(vehicleId).get();

          if (vehicleDoc.exists) {
            final vehicleData = vehicleDoc.data()!;
            bookings.add(
              BookingWithDetails.fromMap({
                ...bookingData,
                'vehicleName': vehicleData['vehicle_name'],
                'vehicleType': vehicleData['vehicle_type'],
              }, doc.id),
            );
          }
        } catch (e) {
          print('Error fetching vehicle details: $e');
        }
      }

      return bookings;
    });
  }

  @override
  Future<List<BookingWithDetails>> fetchApprovedBookings() async {
    final user = _auth.currentUser;
    if (user == null) return [];

    try {
      final bookingsQuery = await _firestore
          .collection('bookings')
          .where('renteeId', isEqualTo: user.uid)
          .where('booking_status', isEqualTo: 'approved')
          .get();

      if (bookingsQuery.docs.isEmpty) return [];

      List<BookingWithDetails> bookingsWithDetails = [];

      for (var bookingDoc in bookingsQuery.docs) {
        final bookingData = bookingDoc.data();
        final vehicleId = bookingData['vehicleId'];

        try {
          final vehicleDoc =
              await _firestore.collection('vehicles').doc(vehicleId).get();

          if (vehicleDoc.exists) {
            final vehicleData = vehicleDoc.data()!;
            bookingsWithDetails.add(
              BookingWithDetails.fromMap({
                ...bookingData,
                'bookingId': bookingDoc.id,
                'vehicleName': vehicleData['vehicle_name'] ?? 'Unnamed Vehicle',
                'vehicleType': vehicleData['vehicle_type'] ?? 'Unknown Type',
                'vehicleDetails': {
                  'name': vehicleData['vehicle_name'] ?? 'Unnamed Vehicle',
                  'plateNo': vehicleData['plate_number'] ?? 'Unknown',
                  'pricePerHour': vehicleData['price_per_hour'] ?? 0.0,
                },
              }, bookingDoc.id),
            );
          }
        } catch (e) {
          print('Error fetching vehicle details: $e');
        }
      }
      return bookingsWithDetails;
    } catch (e) {
      print('Error fetching bookings: $e');
      throw Exception('Failed to fetch approved bookings: $e');
    }
  }

  @override
  Future<void> updateBookingStatus(
    String bookingId,
    String status,
    String renteeStatus,
    String renterStatus,
  ) async {
    await _firestore.collection('bookings').doc(bookingId).update({
      'booking_status': status,
      'renteeStatus': renteeStatus,
      'renterStatus': renterStatus,
    });
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).delete();
    } catch (e) {
      throw Exception('Failed to cancel booking: $e');
    }
  }
}
