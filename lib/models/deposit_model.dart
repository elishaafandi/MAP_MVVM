class DepositModel {
  final String bookingId;
  final String paymentMethod;
  final String paymentStatus;
  final String pickupDate;
  final String pickupTime;
  final String returnDate;
  final String returnTime;
  final DateTime timestamp;
  final double totalDeposit;
  final String vehicleId;
  final String vehicleName;

  DepositModel({
    required this.bookingId,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.pickupDate,
    required this.pickupTime,
    required this.returnDate,
    required this.returnTime,
    required this.timestamp,
    required this.totalDeposit,
    required this.vehicleId,
    required this.vehicleName,
  });

  Map<String, dynamic> toMap() {
    return {
      'bookingId': bookingId,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'pickupDate': pickupDate,
      'pickupTime': pickupTime,
      'returnDate': returnDate,
      'returnTime': returnTime,
      'timestamp': timestamp,
      'totalDeposit': totalDeposit,
      'vehicleId': vehicleId,
      'vehicleName': vehicleName,
    };
  }
}