import 'package:flutter/material.dart';
import 'package:map_mvvm/view/viewmodel.dart';
import 'package:movease/services/vehicle/vehicle_service.dart';

class PreInspectionFormViewModel extends Viewmodel {
  final formKey = GlobalKey<FormState>();
  String carCondition = '';
  String inspectionComments = '';
  final VehicleService _vehicleService;
  bool busy = false;

  PreInspectionFormViewModel(this._vehicleService);

  Map<String, String?> dropdownSelections = {
    'Exterior Condition': null, // Change from '' to null
    'Tires': null,
    'Interior Condition': null,
    'Fuel Level': null,
    'Lights and Signals': null,
    'Engine Sound': null,
    'Brakes': null,
  };

  void updateDropdownSelection(String field, String? value) {
    if (value != null) {
      // Only update if value is not null
      dropdownSelections[field] = value;
      notifyListeners();
    }
  }

  /// Submits the pre-inspection form to Firestore
  Future<void> submitPreInspectionForm(
      String bookingId, Map<String, dynamic> bookingDetails) async {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();
      busy = true;
      notifyListeners();

      await update(() async {
        try {
          await _vehicleService.submitPreInspectionForm({
            'bookingId': bookingId,
            'vehicleId': bookingDetails['vehicleId'],
            'vehicleName': bookingDetails['name'],
            'pricePerHour': bookingDetails['pricePerHour'],
            'pickupDate': bookingDetails['pickupDate'],
            'returnDate': bookingDetails['returnDate'],
            'carCondition': carCondition,
            'inspectionComments': inspectionComments,
            ...dropdownSelections,
          });
        } catch (e) {
          debugPrint('Error saving pre-inspection form: $e');
          // You can add user feedback here (e.g., show a SnackBar).
          rethrow;
        } finally {
          busy = false;
          notifyListeners();
        }
      });
    }
  }
}
