class BookingModel {
  final String location;
  final DateTime pickupDate;
  final String pickupTime;
  final DateTime returnDate;
  final String returnTime;
  final String vehicleId;
  final String userId;

  BookingModel({
    required this.location,
    required this.pickupDate,
    required this.pickupTime,
    required this.returnDate,
    required this.returnTime,
    required this.vehicleId,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'location': location,
      'pickupDate': pickupDate,
      'pickupTime': pickupTime,
      'returnDate': returnDate,
      'returnTime': returnTime,
      'vehicleId': vehicleId,
      'userId': userId,
    };
  }

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      location: map['location'] ?? '',
      pickupDate: map['pickupDate'].toDate(),
      pickupTime: map['pickupTime'] ?? '',
      returnDate: map['returnDate'].toDate(),
      returnTime: map['returnTime'] ?? '',
      vehicleId: map['vehicleId'] ?? '',
      userId: map['userId'] ?? '',
    );
  }
}
