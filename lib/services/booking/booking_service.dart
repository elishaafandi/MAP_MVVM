
import 'package:movease/models/booking_with_details.dart';
import '../../models/booking_model.dart';

abstract class BookingService {
  Future<void> createBooking(BookingModel booking);
  Future<List<BookingModel>> getBookingsForUser(String userId);
  Future<List<BookingModel?>> getBooking(String bookingId);
  Future<void> cancelBooking(String bookingId);
  Stream<List<BookingWithDetails>> getBookingsStreamForUser(String userId);
  Future<void> updateBookingStatus(
    String bookingId,
    String status,
    String renteeStatus,
    String renterStatus,
  );
  Future<List<BookingWithDetails>> fetchApprovedBookings();

}
