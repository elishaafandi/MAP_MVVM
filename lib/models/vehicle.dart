enum VehicleType { car, motorcycle, scooter, bicycle }

class Vehicle {
  final String id;
  final String name;
  final String type;
  final double price;
  final String userId;
  final bool availability;

  Vehicle({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    required this.userId,
    required this.availability,
  });

  factory Vehicle.fromMap(String id, Map<String, dynamic> data) {
    bool availability = data['availability'] ?? !data['availability'] ?? true;

    return Vehicle(
      id: id,
      name: data['vehicle_name'] ?? 'Unnamed Vehicle',
      type: data['vehicle_type'] ?? 'Unknown Type',
      price: (data['price_per_hour'] ?? 0).toDouble(),
      userId: data['user_id'] ?? '',
      availability: availability,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'vehicle_name': name,
      'vehicle_type': type,
      'price_per_hour': price,
      'user_id': userId,
      'availability': availability,
      'availabilitytruefalse': !availability,
    };
  }
}
