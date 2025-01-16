import 'package:map_mvvm/view/viewmodel.dart';
import 'package:movease/models/edit_vehicle_model.dart';
import '../../services/vehicle/vehicle_service.dart';


class EditVehicleViewModel extends Viewmodel {
  final VehicleService _vehicleService;
  late VehicleEdit vehicleEdit;
  final String vehicleId;
  final String vehicleType;
  String errorMessage = '';

  EditVehicleViewModel({
    required VehicleService vehicleService,
    required this.vehicleId,
    required Map<String, dynamic> initialData,
    required this.vehicleType,
  }) : _vehicleService = vehicleService {
    vehicleEdit = VehicleEdit.fromMap(initialData);
  }

  // Vehicle name methods
  String get vehicleName => vehicleEdit.vehicleName;
  void updateVehicleName(String name) {
    vehicleEdit.vehicleName = name;
    notifyListeners();
  }

  // Price methods
  double get pricePerHour => vehicleEdit.pricePerHour;
  void updatePricePerHour(double price) {
    vehicleEdit.pricePerHour = price.clamp(5.0, 30.0);
    notifyListeners();
  }

  // Availability methods
  bool get availability => vehicleEdit.availability;
  void updateAvailability(bool value) {
    vehicleEdit.availability = value;
    notifyListeners();
  }

  // Car specific methods
  String get vehicleBrand => vehicleEdit.vehicleBrand;
  String get vehicleModel => vehicleEdit.vehicleModel;
  String get plateNo => vehicleEdit.plateNo;
  String get transmissionType => vehicleEdit.transmissionType;
  String get fuelType => vehicleEdit.fuelType;
  String get seaterType => vehicleEdit.seaterType;

  void updateVehicleBrand(String brand) {
    vehicleEdit.vehicleBrand = brand;
    notifyListeners();
  }

  void updateVehicleModel(String model) {
    vehicleEdit.vehicleModel = model;
    notifyListeners();
  }

  void updatePlateNo(String plateNo) {
    vehicleEdit.plateNo = plateNo;
    notifyListeners();
  }

  void updateTransmissionType(String type) {
    vehicleEdit.transmissionType = type;
    notifyListeners();
  }

  void updateFuelType(String type) {
    vehicleEdit.fuelType = type;
    notifyListeners();
  }

  void updateSeaterType(String type) {
    vehicleEdit.seaterType = type;
    notifyListeners();
  }

  // Motorcycle specific methods
  String get motorcycleType => vehicleEdit.motorcycleType;
  void updateMotorcycleType(String type) {
    vehicleEdit.motorcycleType = type;
    notifyListeners();
  }

  // Scooter specific methods
  String get scooterType => vehicleEdit.scooterType;
  void updateScooterType(String type) {
    vehicleEdit.scooterType = type;
    notifyListeners();
  }

  // Bicycle specific methods
  String get bicycleType => vehicleEdit.bicycleType;
  void updateBicycleType(String type) {
    vehicleEdit.bicycleType = type;
    notifyListeners();
  }

  bool validateForm() {
    if (vehicleName.isEmpty) {
      errorMessage = 'Vehicle name is required';
      notifyListeners();
      return false;
    }

    if (vehicleType.toLowerCase() == 'car' || vehicleType.toLowerCase() == 'motorcycle') {
      if (vehicleBrand.isEmpty || vehicleModel.isEmpty || plateNo.isEmpty) {
        errorMessage = 'All vehicle details are required';
        notifyListeners();
        return false;
      }
    }

    return true;
  }

  Future<bool> saveVehicle() async {
    if (!validateForm()) return false;

    try {
      await update(() async {
        Map<String, dynamic> updateData = {
          'vehicle_name': vehicleName,
          'price_per_hour': pricePerHour,
          'availability': availability,
        };

        switch (vehicleType.toLowerCase()) {
          case 'car':
            updateData.addAll({
              'vehicle_brand': vehicleBrand,
              'vehicle_model': vehicleModel,
              'plate_number': plateNo,
              'transmission_type': transmissionType,
              'fuel_type': fuelType,
              'seater_type': seaterType,
            });
            break;
          case 'motorcycle':
            updateData.addAll({
              'vehicle_brand': vehicleBrand,
              'vehicle_model': vehicleModel,
              'plate_number': plateNo,
              'motorcycle_type': motorcycleType,
            });
            break;
          case 'scooter':
            updateData.addAll({
              'scooter_type': scooterType,
            });
            break;
          case 'bicycle':
            updateData.addAll({
              'bicycle_type': bicycleType,
            });
            break;
        }

        await _vehicleService.updateVehicle(vehicleId, updateData);
      });
      return true;
    } catch (e) {
      errorMessage = 'Failed to update vehicle: ${e.toString()}';
      notifyListeners();
      turnIdle();
      return false;
    }
  }
}