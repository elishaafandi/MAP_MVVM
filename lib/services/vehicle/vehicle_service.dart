import 'package:movease/models/vehicle.dart';

import '../../models/pre_inspection_model.dart';

abstract class VehicleService {
  Future<List<Vehicle>> getVehiclesByUser(String userId);
  Future<void> addVehicle(Vehicle vehicle);
  Future<void> updateVehicle(String vehicleId, Map<String, dynamic> data);
  Future<void> deleteVehicle(String vehicleId);
  Future<List<Vehicle>> fetchVehicles();
  Future<Map<String, dynamic>> getVehicleDetails(String vehicleId);
  Future<void> submitPreInspectionForm(Map<String, dynamic> formData);
  Future<void> updateBookingStatus(String bookingId, String status);
  Future<PreInspectionFormModel?> fetchInspectionForm(String bookingId);
}
