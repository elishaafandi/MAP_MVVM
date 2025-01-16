import 'package:map_mvvm/view/viewmodel.dart';
import 'package:movease/models/motorcycle_model.dart';
import '../../services/vehicle/vehicle_service.dart';
import '../../services/auth/auth_service.dart';

class AddMotorcycleViewModel extends Viewmodel {
  final VehicleService _vehicleService;
  final AuthService _authService;

  String vehicleBrand = '';
  String vehicleModel = '';
  String plateNo = '';
  double pricePerHour = 5.0;
  String motorcycleType = 'Standard';
  bool availability = true;

  final Map<String, List<String>> vehicleBrands = {
    'Yamaha': ['YZF-R15', 'MT-15'],
    'Honda': ['CBR500R', 'Rebel 500'],
    'Suzuki': ['GSX-R750', 'SV650'],
    'Kawasaki': ['Ninja ZX-6R', 'Z650'],
  };

  AddMotorcycleViewModel({
    required VehicleService vehicleService,
    required AuthService authService,
  })  : _vehicleService = vehicleService,
        _authService = authService;

  Future<void> saveMotorcycle() async {
    try {
      final user = _authService.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final motorcycle = Motorcycle(
        vehicleId: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: user.uid,
        vehicleBrand: vehicleBrand,
        vehicleModel: vehicleModel,
        plateNumber: plateNo,
        pricePerHour: pricePerHour,
        motorcycleType: motorcycleType,
        availability: availability,
      );

      await update(() => _vehicleService.addVehicle(motorcycle));
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
