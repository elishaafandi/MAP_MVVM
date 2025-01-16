import 'package:movease/models/vehicle.dart';

class Scooter extends Vehicle {
  final String scooterType;

  Scooter({
    required String vehicleId,
    required String userId,
    required double pricePerHour,
    required this.scooterType,
    required bool availability,
    required String vehicleName,
  }) : super(
          id: vehicleId, 
          name: vehicleName,
          type: 'Scooter',
          price: pricePerHour,
          userId: userId,
          availability: availability,
        );

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'scooter_type': scooterType,
    };
  }

  factory Scooter.fromMap(String id, Map<String, dynamic> data) {
    return Scooter(
      vehicleId: id,
      userId: data['user_id'],
      vehicleName: data['vehicle_name'],
      pricePerHour: data['price_per_hour'],
      scooterType: data['scooter_type'],
      availability: data['availability'] ?? true,
    );
  }
}
