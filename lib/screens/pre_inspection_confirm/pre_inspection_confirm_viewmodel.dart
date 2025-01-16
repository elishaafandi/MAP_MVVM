import 'package:flutter/material.dart';
import 'package:map_mvvm/app/service_locator.dart';
import 'package:map_mvvm/view/viewmodel.dart';
import 'package:movease/configs/constants.dart';
import 'package:movease/models/pre_inspection_model.dart';
import 'package:movease/renter_status_tracker.dart';

import 'package:movease/services/vehicle/vehicle_service.dart';


class PreInspectionConfirmViewModel extends Viewmodel {
  final VehicleService _vehicleService;
  final Map<String, dynamic> bookingDetails;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  PreInspectionConfirmViewModel({
    required this.bookingDetails,
    required this.onConfirm,
    required this.onCancel,
  }) : _vehicleService = ServiceLocator.locator<VehicleService>() {
    _initialize();
  }

  // State variables
  bool _isLoading = true;
  bool _isUpdating = false;
  String? _errorMessage;
  PreInspectionFormModel? _inspectionFormDetails;
  ViewState _state = ViewState.idle;

  // Getters
  bool get isLoading => _isLoading;
  bool get isUpdating => _isUpdating;
  String? get errorMessage => _errorMessage;
  PreInspectionFormModel? get inspectionFormDetails => _inspectionFormDetails;
  ViewState get state => _state;

  // Initialize the viewmodel
  Future<void> _initialize() async {
    await _fetchInspectionFormDetails();
  }

  // Fetch inspection form details
  Future<void> _fetchInspectionFormDetails() async {
    try {
      _setState(ViewState.busy);
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final form = await _vehicleService.fetchInspectionForm(
        bookingDetails['bookingId'],
      );

      if (form != null) {
        _inspectionFormDetails = form;
        _setState(ViewState.idle);
      } else {
        _errorMessage = 'No inspection form found for this booking';
        _setState(ViewState.error);
      }
    } catch (e) {
      _errorMessage = 'Failed to load inspection form: ${e.toString()}';
      _setState(ViewState.error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Confirm inspection
  Future<void> confirmInspection(BuildContext context) async {
    try {
      _isUpdating = true;
      _errorMessage = null;
      notifyListeners();

      await _vehicleService.updateBookingStatus(
        bookingDetails['bookingId'],
        'pre_inspection_confirmed',
      );

      // Call the callback if provided
      onConfirm?.call();

      // Navigate to status tracker
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RenterStatusTracker(
              bookingDetails: bookingDetails,
            ),
          ),
        );
      }
    } catch (e) {
      _errorMessage = 'Failed to update status: ${e.toString()}';
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  // Handle cancellation
  void handleCancel() {
    onCancel?.call();
  }

  // Retry loading if there was an error
  Future<void> retryLoading() async {
    _errorMessage = null;
    await _fetchInspectionFormDetails();
  }

  // Update view state
  void _setState(ViewState newState) {
    _state = newState;
    notifyListeners();
  }

  // Dispose resources if needed
  @override
  void dispose() {
    // Clean up any controllers or streams here if needed
    super.dispose();
  }

  // Helper method to validate inspection form
  bool isFormValid() {
    return _inspectionFormDetails != null &&
        !_isLoading &&
        !_isUpdating &&
        _errorMessage == null;
  }

  // Helper method to get status message
  String getStatusMessage() {
    if (_isLoading) return 'Loading inspection form...';
    if (_isUpdating) return 'Updating status...';
    if (_errorMessage != null) return _errorMessage!;
    if (_inspectionFormDetails == null) return 'No inspection form found';
    return 'Inspection form loaded successfully';
  }

  // Handle refresh
  Future<void> refresh() async {
    await _fetchInspectionFormDetails();
  }

  // Debug method for development
  void debugPrintState() {
    print('PreInspectionConfirmViewModel State:');
    print('isLoading: $_isLoading');
    print('isUpdating: $_isUpdating');
    print('errorMessage: $_errorMessage');
    print('state: $_state');
    print('hasInspectionForm: ${_inspectionFormDetails != null}');
  }
}
