import 'package:map_mvvm/view/viewmodel.dart';
import 'package:movease/models/scooter_model.dart';
import '../../services/vehicle/vehicle_service.dart';
import '../../services/auth/auth_service.dart';

class AddScooterViewModel extends Viewmodel {
  final VehicleService _vehicleService;
  final AuthService _authService;

  String vehicleName = '';
  double pricePerHour = 1.0;
  String scooterType = 'Manual';
  bool availability = true;

  AddScooterViewModel({
    required VehicleService vehicleService,
    required AuthService authService,
  })  : _vehicleService = vehicleService,
        _authService = authService;

  Future<void> saveScooter() async {
    try {
      final user = _authService.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final scooter = Scooter(
        vehicleId: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: user.uid,
        vehicleName: vehicleName,
        pricePerHour: pricePerHour,
        scooterType: scooterType,
        availability: availability,
      );

      await update(() => _vehicleService.addVehicle(scooter));
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
