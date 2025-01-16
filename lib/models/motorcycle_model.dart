import 'package:movease/models/vehicle.dart';

class Motorcycle extends Vehicle {
  final String vehicleBrand;
  final String vehicleModel;
  final String plateNumber;
  final String motorcycleType;

  Motorcycle({
    required String vehicleId,
    required String userId,
    required this.vehicleBrand,
    required this.vehicleModel,
    required this.plateNumber,
    required double pricePerHour,
    required this.motorcycleType,
    required bool availability,
  }) : super(
          id: vehicleId,
          name: '$vehicleBrand $vehicleModel',
          type: 'Motorcycle',
          price: pricePerHour,
          userId: userId,
          availability: availability,
        );

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'vehicle_brand': vehicleBrand,
      'vehicle_model': vehicleModel,
      'plate_number': plateNumber,
      'motorcycle_type': motorcycleType,
    };
  }

  factory Motorcycle.fromMap(String id, Map<String, dynamic> data) {
    return Motorcycle(
      vehicleId: id,
      userId: data['user_id'],
      vehicleBrand: data['vehicle_brand'],
      vehicleModel: data['vehicle_model'],
      plateNumber: data['plate_number'],
      pricePerHour: data['price_per_hour'],
      motorcycleType: data['motorcycle_type'],
      availability: data['availability'] ?? true,
    );
  }
}
