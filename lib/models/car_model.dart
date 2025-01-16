import 'package:movease/models/vehicle.dart';

class Car extends Vehicle {
  final String vehicleBrand;
  final String vehicleModel;
  final String plateNumber;
  final String transmissionType;
  final String fuelType;
  final String seaterType;

  Car({
    required String vehicleId,
    required String userId,
    required this.vehicleBrand,
    required this.vehicleModel,
    required this.plateNumber,
    required double pricePerHour,
    required this.transmissionType,
    required this.fuelType,
    required this.seaterType,
    required bool availability,
  }) : super(
          id: vehicleId,
          name: '$vehicleBrand $vehicleModel',
          type: 'Car',
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
      'transmission_type': transmissionType,
      'fuel_type': fuelType,
      'seater_type': seaterType,
    };
  }

  factory Car.fromMap(String id, Map<String, dynamic> data) {
    return Car(
      vehicleId: id,
      userId: data['user_id'],
      vehicleBrand: data['vehicle_brand'],
      vehicleModel: data['vehicle_model'],
      plateNumber: data['plate_number'],
      pricePerHour: data['price_per_hour'],
      transmissionType: data['transmission_type'],
      fuelType: data['fuel_type'],
      seaterType: data['seater_type'],
      availability: data['availability'] ?? true,
    );
  }
}
