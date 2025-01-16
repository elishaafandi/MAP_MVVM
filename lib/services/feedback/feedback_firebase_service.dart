import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movease/models/feedback_model.dart';
import 'package:movease/services/feedback/feedback_service.dart';

class FirebaseFeedbackService implements FeedbackService {
  final FirebaseFirestore _firestore;

  FirebaseFeedbackService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<FeedbackModel>> getRenterFeedback(String renteeId) {
    return _firestore
        .collection('feedback')
        .where('renteeId', isEqualTo: renteeId)
        .where('feedbackType', isEqualTo: 'rentee')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FeedbackModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  @override
  Stream<List<FeedbackModel>> getRenteeFeedback(String renterId) {
    return _firestore
        .collection('feedback')
        .where('renterId', isEqualTo: renterId)
        .where('feedbackType', isEqualTo: 'renter')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FeedbackModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  @override
  Stream<List<FeedbackModel>> getYourFeedback(String renterId) {
    return _firestore
        .collection('feedback')
        .where('renterId', isEqualTo: renterId)
        .where('feedbackType', isEqualTo: 'renter')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FeedbackModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  @override
  Stream<List<FeedbackModel>> getYourFeedbackRentee(String renteeId) {
    return _firestore
        .collection('feedback')
        .where('renteeId', isEqualTo: renteeId)
        .where('feedbackType', isEqualTo: 'rentee')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FeedbackModel.fromMap(doc.data(), doc.id))
            .toList());
  }
}