import 'package:movease/models/vehicle.dart';

class Bicycle extends Vehicle {
  final String bicycleType;

  Bicycle({
    required String vehicleId,
    required String userId,
    required double pricePerHour,
    required this.bicycleType,
    required bool availability,
    required String vehicleName,
  }) : super(
          id: vehicleId,
          name: vehicleName,
          type: 'Bicycle',
          price: pricePerHour,
          userId: userId,
          availability: availability,
        );

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'bicycle_type': bicycleType,
    };
  }

  factory Bicycle.fromMap(String id, Map<String, dynamic> data) {
    return Bicycle(
      vehicleId: id,
      userId: data['user_id'],
      vehicleName: data['vehicle_name'],
      pricePerHour: data['price_per_hour'],
      bicycleType: data['bicycle_type'],
      availability: data['availability'] ?? true,
    );
  }
}
