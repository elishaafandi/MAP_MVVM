import 'package:map_mvvm/view/viewmodel.dart';
import 'package:movease/models/car_model.dart';
import '../../services/vehicle/vehicle_service.dart';
import '../../services/auth/auth_service.dart';

class AddCarViewModel extends Viewmodel {
  final VehicleService _vehicleService;
  final AuthService _authService;

  String vehicleBrand = '';
  String vehicleModel = '';
  String plateNo = '';
  double pricePerHour = 10.0;
  String transmissionType = 'Manual';
  String fuelType = 'Petrol';
  String seaterType = '4 Seater';
  bool availability = true;

  final Map<String, List<String>> vehicleBrands = {
    'Perodua': ['Axia', 'Myvi', 'Bezza'],
    'Proton': ['Saga', 'X70', 'Persona'],
    'Honda': ['Civic', 'City'],
    'Toyota': ['Avanza', 'Vios', 'Hilux'],
    'Suzuki': ['Swift', 'Celerio'],
  };

  AddCarViewModel({
    required VehicleService vehicleService,
    required AuthService authService,
  })  : _vehicleService = vehicleService,
        _authService = authService;

  Future<void> saveCar() async {
    try {
      final user = _authService.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final car = Car(
        vehicleId: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: user.uid,
        vehicleBrand: vehicleBrand,
        vehicleModel: vehicleModel,
        plateNumber: plateNo,
        pricePerHour: pricePerHour,
        transmissionType: transmissionType,
        fuelType: fuelType,
        seaterType: seaterType,
        availability: availability,
      );

      await update(() => _vehicleService.addVehicle(car));
      notifyListeners();
    } catch (e) {
      turnIdle();
      rethrow;
    }
  }

  void updateBrand(String brand) {
    vehicleBrand = brand;
    vehicleModel = '';
    notifyListeners();
  }

  void updateModel(String model) {
    vehicleModel = model;
    notifyListeners();
  }

  void updatePrice(double price) {
    pricePerHour = price;
    notifyListeners();
  }
  
}
