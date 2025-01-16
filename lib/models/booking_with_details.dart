class BookingWithDetails {
  final String bookingId;
  final String vehicleName;
  final String vehicleType;
  final String status;
  final String pickupDate;
  final String pickupTime;
  final String returnDate;
  final String returnTime;
  final String renteeId;
  final String renterId;
  final String vehicleId;
  final String renteeStatus;
  final String renterStatus;
  final String location;
  final double pricePerHour;

  BookingWithDetails({
    required this.bookingId,
    required this.vehicleName,
    required this.vehicleType,
    required this.status,
    required this.pickupDate,
    required this.pickupTime,
    required this.returnDate,
    required this.returnTime,
    required this.renteeId,
    required this.renterId,
    required this.vehicleId,
    required this.renteeStatus,
    required this.renterStatus,
    required this.location,
    required this.pricePerHour,
  });

  String get currentStatus => status;

  // Add plateNo getter that returns vehicleId
  String get plateNo => vehicleId;

  // Add totalPrice getter that calculates total price based on duration
  double get calculateTotalPrice {
    try {
      // Parse dates
      final pickupDateTime = DateTime.parse(pickupDate);
      final returnDateTime = DateTime.parse(returnDate);

      // Split times
      final pickupTimeParts = pickupTime.split(':');
      final returnTimeParts = returnTime.split(':');

      // Create full datetime objects
      final start = DateTime(
        pickupDateTime.year,
        pickupDateTime.month,
        pickupDateTime.day,
        int.parse(pickupTimeParts[0]),
        int.parse(pickupTimeParts[1]),
      );

      final end = DateTime(
        returnDateTime.year,
        returnDateTime.month,
        returnDateTime.day,
        int.parse(returnTimeParts[0]),
        int.parse(returnTimeParts[1]),
      );

      final hours = end.difference(start).inHours.toDouble();
      print('Debug calculateTotalPrice:');
      print('Start: $start');
      print('End: $end');
      print('Hours: $hours');
      print('Price per hour: $pricePerHour');
      print('Total price: ${hours * pricePerHour}');

      return hours * pricePerHour;
    } catch (e) {
      print('Error calculating total price: $e');
      return 0.0;
    }
  }

  Map<String, dynamic> get vehicleDetails {
    return {
      'name': vehicleName,
      'plateNo': plateNo,
      'pricePerHour': pricePerHour,
    };
  }

  factory BookingWithDetails.fromMap(Map<String, dynamic> map, String id) {
    return BookingWithDetails(
      bookingId: id,
      vehicleName: map['vehicleName'] ?? 'Unknown Vehicle',
      vehicleType: map['vehicleType'] ?? 'Unknown Type',
      status: map['booking_status'] ?? 'pending',
      pickupDate: map['pickupDate'] ?? '',
      pickupTime: map['pickupTime'] ?? '',
      returnDate: map['returnDate'] ?? '',
      returnTime: map['returnTime'] ?? '',
      renteeId: map['renteeId'] ?? '',
      renterId: map['renterId'] ?? '',
      vehicleId: map['vehicleId'] ?? '',
      renteeStatus: map['renteeStatus'] ?? '',
      renterStatus: map['renterStatus'] ?? '',
      location: map['location'] ?? 'Unknown Location',
      pricePerHour: (map['pricePerHour'] ?? 0.0).toDouble(),
    );
  }
}
