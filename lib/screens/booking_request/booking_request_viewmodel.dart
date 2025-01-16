import 'package:map_mvvm/view/viewmodel.dart';
import '../../services/booking/booking_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingRequestViewModel extends Viewmodel {
  final BookingService _bookingService;
  String _selectedStatus = 'All';
  bool _isLoading = false;
  List<Map<String, dynamic>> _bookings = [];

  BookingRequestViewModel({required BookingService bookingService})
      : _bookingService = bookingService;

  String get selectedStatus => _selectedStatus;
  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get bookings => _bookings;

  void setStatus(String status) {
    _selectedStatus = status;
    fetchBookings();
    notifyListeners();
  }

  Future<void> fetchBookings() async {
    try {
      _isLoading = true;
      notifyListeners();

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      Query bookingsQuery = FirebaseFirestore.instance.collection('bookings');

      if (_selectedStatus != 'All') {
        bookingsQuery = bookingsQuery.where('booking_status',
            isEqualTo: _selectedStatus.toLowerCase());
      }

      final bookingsSnapshot = await bookingsQuery.get();
      _bookings = [];

      for (var bookingDoc in bookingsSnapshot.docs) {
        final bookingData = bookingDoc.data() as Map<String, dynamic>;
        final vehicleId = bookingData['vehicleId'];

        if (bookingData['createdAt'] is Timestamp) {
          Timestamp timestamp = bookingData['createdAt'] as Timestamp;
          bookingData['createdAt'] = timestamp.toDate().toString();
        }

        final vehicleDoc = await FirebaseFirestore.instance
            .collection('vehicles')
            .doc(vehicleId)
            .get();

        if (vehicleDoc.exists) {
          final vehicleData = vehicleDoc.data()!;
          _bookings.add({
            ...bookingData,
            'bookingId': bookingDoc.id,
            'vehicleName': vehicleData['vehicle_name'],
            'plateNumber': vehicleData['plate_number'],
          });
        }
      }
    } catch (e) {
      print('Error fetching bookings: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateBookingStatus(String bookingId, String newStatus) async {
    try {
      _isLoading = true;
      notifyListeners();

      String renteeStatus =
          newStatus == 'approved' ? 'booking_confirmed' : newStatus;
      String renterStatus =
          newStatus == 'approved' ? 'booking_confirmed' : newStatus;
      await _bookingService.updateBookingStatus(
          bookingId, newStatus, renteeStatus, renterStatus);

      await fetchBookings();
    } catch (e) {
      print('Error updating booking status: $e');
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
