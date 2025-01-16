class Booking {
  final String id;
  final String vehicleId;
  final String renterId;
  final String status;
  final DateTime startTime;
  final DateTime endTime;
  final double totalPrice;

  Booking({
    required this.id,
    required this.vehicleId,
    required this.renterId,
    required this.status,
    required this.startTime,
    required this.endTime,
    required this.totalPrice,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      vehicleId: json['vehicle_id'],
      renterId: json['renter_id'],
      status: json['status'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      totalPrice: json['total_price'].toDouble(),
    );
  }
}
