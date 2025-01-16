import 'dart:async';
import 'package:flutter/material.dart';
import 'package:map_mvvm/view/viewmodel.dart';
import 'package:movease/services/booking/booking_service.dart';
import 'package:movease/services/vehicle/vehicle_service.dart';
import 'package:movease/models/booking_with_details.dart';

class RenterStatusViewModel extends Viewmodel {
  final BookingService _bookingService;
  final VehicleService _vehicleService;
  bool isLoading = false;
  BookingWithDetails? currentBookingDetails;
  List<Map<String, dynamic>> statusSteps = [];
  late StreamSubscription<List<BookingWithDetails>> _bookingSubscription;

  RenterStatusViewModel({
    required BookingService bookingService,
    required VehicleService vehicleService,
  })  : _bookingService = bookingService,
        _vehicleService = vehicleService;

  void setInitialBooking(BookingWithDetails booking) {
    currentBookingDetails = booking;
    setupBookingListener();
    initializeStatusSteps();
  }

  @override
  void init() {}

  void setupBookingListener() {
    if (currentBookingDetails == null) return;

    _bookingSubscription = _bookingService
        .getBookingsStreamForUser(currentBookingDetails!.renteeId)
        .listen((bookings) {
      final updatedBooking = bookings.firstWhere(
        (booking) => booking.bookingId == currentBookingDetails!.bookingId,
        orElse: () => currentBookingDetails!,
      );

      currentBookingDetails = updatedBooking;
      initializeStatusSteps();
      notifyListeners();
    });
  }

  Future<void> fetchBookingDetails() async {
    isLoading = true;
    notifyListeners();

    try {
      final approvedBookings = await _bookingService.fetchApprovedBookings();
      if (approvedBookings.isNotEmpty) {
        currentBookingDetails = approvedBookings.first;

        final vehicleDetails = await _vehicleService.getVehicleDetails(
          currentBookingDetails!.vehicleId,
        );

        currentBookingDetails = BookingWithDetails.fromMap({
          'bookingId': currentBookingDetails!.bookingId,
          'vehicleName': currentBookingDetails!.vehicleName,
          'vehicleType': currentBookingDetails!.vehicleType,
          'status': currentBookingDetails!.status,
          'pickupDate': currentBookingDetails!.pickupDate,
          'pickupTime': currentBookingDetails!.pickupTime,
          'returnDate': currentBookingDetails!.returnDate,
          'returnTime': currentBookingDetails!.returnTime,
          'renteeId': currentBookingDetails!.renteeId,
          'renterId': currentBookingDetails!.renterId,
          'vehicleId': currentBookingDetails!.vehicleId,
          'renteeStatus': currentBookingDetails!.renteeStatus,
          'location': currentBookingDetails!.location,
          'pricePerHour': currentBookingDetails!.pricePerHour,
          'vehicleDetails': vehicleDetails,
        }, currentBookingDetails!.bookingId);

        initializeStatusSteps();
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> handleStatusUpdate(String action) async {
    if (currentBookingDetails == null) return;

    isLoading = true;
    notifyListeners();

    try {
      await _bookingService.updateBookingStatus(
        currentBookingDetails!.bookingId,
        currentBookingDetails!.status,
        action,
        currentBookingDetails!.renteeStatus,
      );

      await fetchBookingDetails();
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void initializeStatusSteps() {
    if (currentBookingDetails == null) return;

    final currentStatus = currentBookingDetails!.renteeStatus;
    statusSteps = [
       {
        "title": "Booking Confirmed",
        "description": currentStatus == "deposit_payment_completed"
            ? "Confirm deposit payment"
            : "Waiting for deposit payment",
        "buttonText": currentStatus == "deposit_payment_completed" 
            ? "CONFIRM DEPOSIT PAYMENT"
            : null,
        "isCompleted": currentStatus != "booking_confirmed" &&
            currentStatus != "deposit_payment_completed",
        "isActive": currentStatus == "deposit_payment_completed" ,
        "icon": Icons.check_circle,
      },
      {
        "title": "Vehicle Delivery",
        "description": currentStatus == "deposit_payment_confirmed"
            ? "Start vehicle delivery process"
            : "Waiting for delivery confirmation",
        "buttonText": currentStatus == "deposit_payment_confirmed"
            ? "MAKE DELIVERY"
            : null,
        "isCompleted": currentStatus == "vehicle_delivery" ||
            currentStatus == "vehicle_delivery_confirmed" ||
            currentStatus == "pre_inspection_completed" ||
            currentStatus == "use_vehicle_confirmed" ||
            currentStatus == "return_vehicle" ||
            currentStatus == "post_inspection_completed" ||
            currentStatus == "post_inspection_confirmed" ||
            currentStatus == "final_payment_confirmed" ||
            currentStatus == "booking_completed" ||
            currentStatus == "rentee_rated",
        "isActive": currentStatus == "deposit_payment_confirmed",
        "icon": Icons.local_shipping,
      },
      {
        "title": "Pre-inspection Form",
        "description": currentStatus == "pre_inspection_completed"
            ? "Waiting for pre-inspection completion"
            : "Pre-Inspection Form Confirmed",
        "buttonText": currentStatus == "pre_inspection_completed"
            ? "CONFIRM PRE-INSPECTION"
            : null,
        "isCompleted": currentStatus == "pre_inspection_confirmed" ||
            currentStatus == "use_vehicle_confirmed" ||
            currentStatus == "return_vehicle_confirmed" ||
            currentStatus == "post_inspection_completed" ||
            currentStatus == "post_inspection_confirmed" ||
            currentStatus == "final_payment_confirmed" ||
            currentStatus == "booking_completed" ||
            currentStatus == "rentee_rated",
        "isActive": currentStatus == "pre_inspection_completed",
        "icon": Icons.assignment,
      },
      {
        "title": "Return Vehicle Confirmation",
        "description": currentStatus == "return_vehicle"
            ? "Waiting for return request"
            : "Confirm vehicle return",
        "buttonText": currentStatus == "return_vehicle" 
            ? "CONFIRM RETURN"
            : null,
        "isCompleted": currentStatus == "return_vehicle_confirmed" ||
            currentStatus == "post_inspection_completed" ||
            currentStatus == "post_inspection_confirmed" ||
            currentStatus == "final_payment_confirmed" ||
            currentStatus == "booking_completed" ||
            currentStatus == "rentee_rated",
        "isActive": currentStatus == "return_vehicle",
        "icon": Icons.assignment_return,
      },
      {
        "title": "Post-inspection Form",
        "description": currentStatus == "return_vehicle_confirmed"
            ? "Waiting for post-inspection"
            : "Complete post-inspection form",
        "buttonText": currentStatus == "return_vehicle_confirmed"
            ? "FILL POST-INSPECTION"
            : null,
        "isCompleted": currentStatus == "post_inspection_completed" ||
            currentStatus == "final_payment_confirmed" ||
            currentStatus == "booking_completed" ||
            currentStatus == "rentee_rated",
        "isActive": currentStatus == "return_vehicle_confirmed",
        "icon": Icons.fact_check,
      },
      {
        "title": "Final Payment",
        "description": currentStatus == "final_payment_completed"
            ? "Confirm final payment"
            : "Waiting for final payment",
        "buttonText": currentStatus == "final_payment_completed" &&
                currentStatus == "final_payment_completed"
            ? "CONFIRM FINAL PAYMENT"
            : null,
        "isCompleted": currentStatus == "final_payment_confirmed" ||
            currentStatus == "booking_completed" ||
            currentStatus == "rentee_rated",
        "isActive": currentStatus == "final_payment_completed",
        "icon": Icons.payment,
      },
      {
        "title": "Complete Booking",
        "description": currentStatus == "final_payment_confirmed"
            ? "Rate rentee"
            : "Booking completed successfully",
        "buttonText": currentStatus == "final_payment_confirmed"
            ? "COMPLETE BOOKING"
            : null,
        "isCompleted": currentStatus == "booking_completed" ||
            currentStatus == "rentee_rated",
        "isActive": currentStatus == "final_payment_confirmed",
        "icon": Icons.star,
      },
      {
        "title": "Booking Completed",
        "description": currentStatus == "renteerated"
            ? "Rentee has completed their rating"
            : currentStatus == "booking_completed"
                ? "Rate rentee"
                : "Booking completed successfully",
        "buttonText": currentStatus == "booking_completed" &&
                currentStatus != "renteerated"
            ? "RATE RENTEE"
            : null,
        "isCompleted": currentStatus == "rentee_rated",
        "isActive": currentStatus == "booking_completed" ||
            currentStatus == "renteerated",
        "icon": Icons.star,
      },
    ];
  }

  @override
  void dispose() {
    _bookingSubscription.cancel();
    super.dispose();
  }
}
