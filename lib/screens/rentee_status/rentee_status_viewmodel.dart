import 'dart:async';
import 'package:flutter/material.dart';
import 'package:map_mvvm/view/viewmodel.dart';
import 'package:movease/services/booking/booking_service.dart';
import 'package:movease/services/vehicle/vehicle_service.dart';
import 'package:movease/models/booking_with_details.dart';

class RenteeStatusViewModel extends Viewmodel {
  final BookingService _bookingService;
  final VehicleService _vehicleService;
  bool isLoading = false;
  BookingWithDetails? currentBookingDetails;
  List<Map<String, dynamic>> statusSteps = [];
  late StreamSubscription<List<BookingWithDetails>> _bookingSubscription;

  RenteeStatusViewModel({
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
        "description": currentStatus == "booking_confirmed"
            ? "Make deposit payment"
            : "Deposit payment in process",
        "buttonText":
            currentStatus == "booking_confirmed" ? "MAKE PAYMENT" : null,
        "isCompleted": currentStatus != "booking_confirmed",
        "isActive": currentStatus == "booking_confirmed",
        "icon": Icons.check_circle,
      },
      {
        "title": "Vehicle Delivery Confirmation",
        "description": currentStatus == "vehicle_delivery"
            ? "Confirm vehicle delivery"
            : "Waiting for vehicle delivery",
        "buttonText":
            currentStatus == "vehicle_delivery" ? "CONFIRM DELIVERY" : null,
        "isCompleted": currentStatus == 'vehicle_delivery_confirmed' ||
            currentStatus == 'pre_inspection_completed' ||
            currentStatus == 'use_vehicle_confirmed' ||
            currentStatus == 'return_vehicle' ||
            currentStatus == "post_inspection_confirmed" ||
            currentStatus == 'final_payment_completed' ||
            currentStatus == 'booking_completed' ||
            currentStatus == 'renter_rated',
        "isActive": (currentStatus == "vehicle_delivery"),
        "icon": Icons.local_shipping,
      },
      {
        "title": "Pre-inspection Form",
        "description": currentStatus == "vehicle_delivery_confirmed"
            ? "Fill pre-inspection form"
            : "Waiting for pre-inspection",
        "buttonText": currentStatus == "vehicle_delivery_confirmed"
            ? "FILL PRE-INSPECTION"
            : null,
        "isCompleted": currentStatus == 'pre_inspection_completed' ||
            currentStatus == 'use_vehicle_confirmed' ||
            currentStatus == 'return_vehicle' ||
            currentStatus == "post_inspection_confirmed" ||
            currentStatus == 'final_payment_completed' ||
            currentStatus == 'booking_completed' ||
            currentStatus == 'renter_rated',
        "isActive": currentStatus == "vehicle_delivery_confirmed",
        "icon": Icons.assignment,
      },
      {
        "title": "Start Usage",
        "description": currentStatus == "pre_inspection_confirmed"
            ? "Complete pre-inspection first"
            : "Start using vehicle",
        "buttonText":
            currentStatus == "pre_inspection_confirmed" ? "START USING" : null,
        "isCompleted": currentStatus == "use_vehicle_confirmed" ||
            currentStatus == "return_vehicle" ||
            currentStatus == "post_inspection_completed" ||
            currentStatus == "post_inspection_confirmed" ||
            currentStatus == "final_payment_confirmed" ||
            currentStatus == "booking_completed" ||
            currentStatus == "renter_rated",
        "isActive": currentStatus == "pre_inspection_confirmed",
        "icon": Icons.drive_eta,
      },
      {
        "title": "Return Vehicle",
        "description": currentStatus == "use_vehicle_confirmed"
            ? "Request vehicle return"
            : "Waiting Vehicle Return Confirmation",
        "buttonText":
            currentStatus == "use_vehicle_confirmed" ? "RETURN VEHICLE" : null,
        "isCompleted": currentStatus == "return_vehicle" ||
            currentStatus == "post_inspection_confirmed" ||
            currentStatus == "final_payment_confirmed" ||
            currentStatus == "booking_completed" ||
            currentStatus == "rated",
        "isActive": currentStatus == "use_vehicle_confirmed",
        "icon": Icons.assignment_return,
      },
      {
        "title": "Post-inspection Form",
        "description": currentStatus == "post_inspection_completed"
            ? "Confirm post-inspection form"
            : "Waiting for post-inspection",
        "buttonText": currentStatus == "post_inspection_completed" &&
                currentStatus == "post_inspection_completed"
            ? "CONFIRM POST-INSPECTION"
            : null,
        "isCompleted": currentStatus == "post_inspection_confirmed" ||
            currentStatus == "final_payment_completed" ||
            currentStatus == "booking_completed" ||
            currentStatus == "renter_rated",
        "isActive": currentStatus == "post_inspection_completed" &&
            currentStatus == "post_inspection_completed",
        "icon": Icons.fact_check,
      },
      {
        "title": "Final Payment",
        "description": currentStatus == "post_inspection_confirmed"
            ? "Make final payment"
            : "Waiting for payment status",
        "buttonText": currentStatus == "post_inspection_confirmed"
            ? "MAKE FINAL PAYMENT"
            : null,
        "isCompleted": currentStatus == "final_payment_completed" ||
            currentStatus == "booking_completed" ||
            currentStatus == "renter_rated",
        "isActive": currentStatus == "post_inspection_confirmed",
        "icon": Icons.payment,
      },
      {
        "title": "Final Payment",
        "description": currentStatus == "post_inspection_confirmed"
            ? "Make final payment"
            : "Waiting for payment status",
        "buttonText": currentStatus == "post_inspection_confirmed"
            ? "MAKE FINAL PAYMENT"
            : null,
        "isCompleted": currentStatus == "booking_completed" ||
            currentStatus == "renter_rated",
        "isActive": currentStatus == "post_inspection_confirmed",
        "icon": Icons.payment,
      },
      {
        "title": "Booking Complete",
        "description": currentStatus == 'rentee_rated'
            ? "Rate renter"
            : "Booking completed successfully",
        "buttonText": currentStatus == 'rentee_rated' ? "RATE RENTER" : null,
        "isCompleted": currentStatus == "renter_rated",
        "isActive": currentStatus == 'rentee_rated',
        "icon": Icons.star,
      }
    ];
  }

  @override
  void dispose() {
    _bookingSubscription.cancel();
    super.dispose();
  }
}
