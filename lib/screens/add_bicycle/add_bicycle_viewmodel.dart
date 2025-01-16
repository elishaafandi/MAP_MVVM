import 'package:map_mvvm/view/viewmodel.dart';
import 'package:movease/models/bicycle_model.dart';
import '../../services/vehicle/vehicle_service.dart';
import '../../services/auth/auth_service.dart';

class AddBicycleViewModel extends Viewmodel {
  final VehicleService _vehicleService;
  final AuthService _authService;

  String vehicleName = '';
  double pricePerHour = 3.0;
  String bicycleType = 'Mountain';
  bool availability = true;

  AddBicycleViewModel({
    required VehicleService vehicleService,
    required AuthService authService,
  })  : _vehicleService = vehicleService,
        _authService = authService;

  Future<void> saveBicycle() async {
    try {
      final user = _authService.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final bicycle = Bicycle(
        vehicleId: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: user.uid,
        vehicleName: vehicleName,
        pricePerHour: pricePerHour,
        bicycleType: bicycleType,
        availability: availability,
      );

      await update(() => _vehicleService.addVehicle(bicycle));
      notifyListeners();
    } catch (e) {
      turnIdle();
      rethrow;
    }
  }

  void updateName(String name) {
    vehicleName = name;
    notifyListeners();
  }

  void updatePrice(double price) {
    pricePerHour = price;
    notifyListeners();
  }
}
