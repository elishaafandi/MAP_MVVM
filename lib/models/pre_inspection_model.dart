class PreInspectionFormModel {
  final String vehicleName;
  final String vehicleId;
  final String pickupDate;
  final String returnDate;
  final double pricePerHour;
  final String carCondition;
  final String exteriorCondition;
  final String interiorCondition;
  final String tires;
  final String fuelLevel;
  final String lightsAndSignals;
  final String engineSound;
  final String brakes;
  final String inspectionComments;

  PreInspectionFormModel({
    required this.vehicleName,
    required this.vehicleId,
    required this.pickupDate,
    required this.returnDate,
    required this.pricePerHour,
    required this.carCondition,
    required this.exteriorCondition,
    required this.interiorCondition,
    required this.tires,
    required this.fuelLevel,
    required this.lightsAndSignals,
    required this.engineSound,
    required this.brakes,
    required this.inspectionComments,
  });

  factory PreInspectionFormModel.fromMap(Map<String, dynamic> data) {
    return PreInspectionFormModel(
      vehicleName: data['vehicleName'] ?? '',
      vehicleId: data['vehicleId'] ?? '',
      pickupDate: data['pickupDate'] ?? '',
      returnDate: data['returnDate'] ?? '',
      pricePerHour: data['pricePerHour'] ?? 0.0,
      carCondition: data['carCondition'] ?? '',
      exteriorCondition: data['Exterior Condition'] ?? '',
      interiorCondition: data['Interior Condition'] ?? '',
      tires: data['Tires'] ?? '',
      fuelLevel: data['Fuel Level'] ?? '',
      lightsAndSignals: data['Lights and Signals'] ?? '',
      engineSound: data['Engine Sound'] ?? '',
      brakes: data['Brakes'] ?? '',
      inspectionComments: data['inspectionComments'] ?? '',
    );
  }
}
