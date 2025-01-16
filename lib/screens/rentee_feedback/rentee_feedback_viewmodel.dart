import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:map_mvvm/view/viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movease/models/feedback_model.dart';
import 'package:movease/services/feedback/feedback_service.dart';

class RenteeFeedbackViewModel extends Viewmodel {
  final FeedbackService _feedbackService;
  final FirebaseAuth _auth;

  RenteeFeedbackViewModel({
    required FeedbackService feedbackService,
    FirebaseAuth? auth,
  })  : _feedbackService = feedbackService,
        _auth = auth ?? FirebaseAuth.instance;

  Stream<List<FeedbackModel>> get renterFeedbackStream {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);
    return _feedbackService.getRenterFeedback(user.uid);
  }

  Stream<List<FeedbackModel>> get yourFeedbackStream {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);
    return _feedbackService.getYourFeedback(user.uid);
  }

  ImageProvider? getImageProvider(String? base64String) {
    if (base64String == null || base64String.isEmpty) {
      return null;
    }
    try {
      return MemoryImage(base64Decode(base64String));
    } catch (e) {
      print('Error decoding base64 image: $e');
      return null;
    }
  }
}