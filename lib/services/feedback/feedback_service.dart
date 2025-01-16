import 'package:movease/models/feedback_model.dart';

abstract class FeedbackService {
  Stream<List<FeedbackModel>> getRenterFeedback(String renteeId);
  Stream<List<FeedbackModel>> getRenteeFeedback(String renterId);
  Stream<List<FeedbackModel>> getYourFeedback(String renterId);
  Stream<List<FeedbackModel>> getYourFeedbackRentee(String renteeId);
}
