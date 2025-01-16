class VehicleEdit {
  String vehicleName;
  String vehicleBrand;
  String vehicleModel;
  String plateNo;
  double pricePerHour;
  String transmissionType;
  String fuelType;
  String seaterType;
  String motorcycleType;
  String scooterType;
  String bicycleType;
  bool availability;

  VehicleEdit({
    required this.vehicleName,
    this.vehicleBrand = '',
    this.vehicleModel = '',
    this.plateNo = '',
    required this.pricePerHour,
    this.transmissionType = 'Automatic',
    this.fuelType = 'Petrol',
    this.seaterType = '4',
    this.motorcycleType = 'Standard',
    this.scooterType = 'Electric',
    this.bicycleType = 'Mountain',
    required this.availability,
  });

  factory VehicleEdit.fromMap(Map<String, dynamic> map) {
    return VehicleEdit(
      vehicleName: map['vehicle_name'] ?? '',
      vehicleBrand: map['vehicle_brand'] ?? '',
      vehicleModel: map['vehicle_model'] ?? '',
      plateNo: map['plate_number'] ?? '',
      pricePerHour: (map['price_per_hour'] ?? 5.0).toDouble(),
      transmissionType: map['transmission_type'] ?? 'Automatic',
      fuelType: map['fuel_type'] ?? 'Petrol',
      seaterType: map['seater_type'] ?? '4',
      motorcycleType: map['motorcycle_type'] ?? 'Standard',
      scooterType: map['scooter_type'] ?? 'Electric',
      bicycleType: map['bicycle_type'] ?? 'Mountain',
      availability: map['availability'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'vehicle_name': vehicleName,
      'vehicle_brand': vehicleBrand,
      'vehicle_model': vehicleModel,
      'plate_number': plateNo,
      'price_per_hour': pricePerHour,
      'transmission_type': transmissionType,
      'fuel_type': fuelType,
      'seater_type': seaterType,
      'motorcycle_type': motorcycleType,
      'scooter_type': scooterType,
      'bicycle_type': bicycleType,
      'availability': availability,
    };
  }
}
