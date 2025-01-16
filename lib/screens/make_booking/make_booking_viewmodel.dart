import 'package:flutter/material.dart';
import 'package:map_mvvm/view/viewmodel.dart';
import 'package:movease/models/booking_model.dart';
import '../../services/vehicle/vehicle_service.dart';
import '../../services/booking/booking_service.dart';

class MakeBookingViewModel extends Viewmodel {
  final VehicleService _vehicleService;
  final BookingService _bookingService;
  
  Map<String, dynamic>? _vehicleDetails;
  bool _isLoading = false;
  String? _errorMessage;

  final TextEditingController locationController = TextEditingController();
  final TextEditingController pickupDateController = TextEditingController();
  final TextEditingController pickupTimeController = TextEditingController();
  final TextEditingController returnDateController = TextEditingController();
  final TextEditingController returnTimeController = TextEditingController();

  // Getters
  Map<String, dynamic>? get vehicleDetails => _vehicleDetails;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  MakeBookingViewModel({
    required VehicleService vehicleService,
    required BookingService bookingService,
  }) : _vehicleService = vehicleService,
       _bookingService = bookingService;

  Future<void> fetchVehicleDetails(String vehicleId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _vehicleDetails = await _vehicleService.getVehicleDetails(vehicleId);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to fetch vehicle details';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> submitBooking(String vehicleId) async {
    if (!_validateInputs()) return false;

    final booking = BookingModel(
      location: locationController.text,
      pickupDate: DateTime.parse(pickupDateController.text),
      pickupTime: pickupTimeController.text,
      returnDate: DateTime.parse(returnDateController.text),
      returnTime: returnTimeController.text,
      vehicleId: vehicleId,
      userId: 'current-user-id', // Get from auth service
    );

    try {
      await _bookingService.createBooking(booking);
      return true;
    } catch (e) {
      _errorMessage = 'Failed to submit booking';
      notifyListeners();
      return false;
    }
  }

  bool _validateInputs() {
    if (locationController.text.isEmpty ||
        pickupDateController.text.isEmpty ||
        pickupTimeController.text.isEmpty ||
        returnDateController.text.isEmpty ||
        returnTimeController.text.isEmpty) {
      _errorMessage = 'All fields are required';
      notifyListeners();
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    locationController.dispose();
    pickupDateController.dispose();
    pickupTimeController.dispose();
    returnDateController.dispose();
    returnTimeController.dispose();
    super.dispose();
  }

  bool validateBookingDates(String pickupDate, String returnDate) {
    if (pickupDate.isEmpty || returnDate.isEmpty) {
      return false;
    }

    try {
      DateTime now = DateTime.now();
      DateTime minBookingDate = now.add(Duration(days: 2));
      DateTime pickup = DateTime.parse(pickupDate);
      DateTime return_ = DateTime.parse(returnDate);

      // Check if pickup date is at least 2 days from now
      if (pickup.isBefore(minBookingDate)) {
        _errorMessage = 'Booking must be made at least 2 days in advance';
        notifyListeners();
        return false;
      }

      // Check if return date is after pickup date
      if (return_.isBefore(pickup)) {
        _errorMessage = 'Return date must be after pickup date';
        notifyListeners();
        return false;
      }

      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = 'Invalid date format';
      notifyListeners();
      return false;
    }
  }

  bool validateBookingTimes(String pickupTime, String returnTime) {
    if (pickupTime.isEmpty || returnTime.isEmpty) {
      return false;
    }

    try {
      // Parse times (assuming format is HH:mm)
      final pickupHour = int.parse(pickupTime.split(':')[0]);
      final returnHour = int.parse(returnTime.split(':')[0]);

      // Check if times are within operating hours (8 AM to 10 PM)
      if (pickupHour < 8 || pickupHour > 22) {
        _errorMessage = 'Pickup time must be between 8 AM and 10 PM';
        notifyListeners();
        return false;
      }

      if (returnHour < 8 || returnHour > 22) {
        _errorMessage = 'Return time must be between 8 AM and 10 PM';
        notifyListeners();
        return false;
      }

      // Check if return time is after pickup time
      if (returnHour <= pickupHour) {
        _errorMessage = 'Return time must be after pickup time';
        notifyListeners();
        return false;
      }

      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = 'Invalid time format';
      notifyListeners();
      return false;
    }
  }
}