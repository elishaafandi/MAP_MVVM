class FeedbackModel {
  final String id;
  final String renteeId;
  final String renterId;
  final String vehicleName;
  final String pickupDate;
  final List<String> selectedFeedback;
  final int rating;
  final String feedbackType;
  final String vehicleId;

  FeedbackModel({
    required this.id,
    required this.renteeId,
    required this.renterId,
    required this.vehicleName,
    required this.pickupDate,
    required this.selectedFeedback,
    required this.rating,
    required this.feedbackType,
    required this.vehicleId,
  });

  Map<String, dynamic> toMap() {
    return {
      'renteeId': renteeId,
      'renterId': renterId,
      'vehicleName': vehicleName,
      'pickupDate': pickupDate,
      'selectedFeedback': selectedFeedback,
      'rating': rating,
      'feedbackType': feedbackType,
      'vehicleId': vehicleId,
    };
  }

  factory FeedbackModel.fromMap(Map<String, dynamic> map, String documentId) {
    return FeedbackModel(
      id: documentId,
      renteeId: map['renteeId'] ?? '',
      renterId: map['renterId'] ?? '',
      vehicleName: map['vehicleName'] ?? '',
      pickupDate: map['pickupDate'] ?? '',
      selectedFeedback: List<String>.from(map['selectedFeedback'] ?? []),
      rating: map['rating']?.toInt() ?? 0,
      feedbackType: map['feedbackType'] ?? '',
      vehicleId: map['vehicleId'] ?? '',
    );
  }
}