import 'package:flutter/material.dart';
import 'package:map_mvvm/view/view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movease/models/feedback_model.dart';
import 'dart:convert';
import 'rentee_feedback_viewmodel.dart';

class RenteeFeedbackView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewWrapper<RenteeFeedbackViewModel>(
      builder: (context, viewModel) {
        return Scaffold(
          backgroundColor: Color(0xFF2A2A2A),
          appBar: AppBar(
            title: Text('Feedback', style: TextStyle(fontWeight: FontWeight.w600)),
            backgroundColor: Colors.yellow[700],
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    icon: Icons.feedback,
                    title: 'FEEDBACK FROM RENTER',
                    child: _buildFeedbackList(
                      context,
                      viewModel,
                      viewModel.renterFeedbackStream,
                    ),
                  ),
                  SizedBox(height: 24),
                  _buildSection(
                    icon: Icons.comment,
                    title: 'YOUR FEEDBACK',
                    child: _buildFeedbackList(
                      context,
                      viewModel,
                      viewModel.yourFeedbackStream,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF3A3A3A),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.yellow[700]!.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.yellow[700], size: 24),
              ),
              SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildFeedbackList(
    BuildContext context,
    RenteeFeedbackViewModel viewModel,
    Stream<List<FeedbackModel>> stream,
  ) {
    return StreamBuilder<List<FeedbackModel>>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}',
              style: TextStyle(color: Colors.red));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(color: Colors.yellow[700]));
        }

        final feedbacks = snapshot.data ?? [];
        if (feedbacks.isEmpty) {
          return Text(
            "No feedback found",
            style: TextStyle(color: Colors.white),
          );
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: feedbacks.map((feedback) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: _buildFeedbackCard(context, viewModel, feedback),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildFeedbackCard(
    BuildContext context,
    RenteeFeedbackViewModel viewModel,
    FeedbackModel feedback,
  ) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.yellow[700]!.withOpacity(0.3)),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserInfo(context, viewModel, feedback),
          SizedBox(height: 16),
          Divider(color: Colors.grey[800]),
          SizedBox(height: 16),
          _buildFeedbackContent(feedback),
          SizedBox(height: 16),
          _buildVehicleInfo(feedback),
        ],
      ),
    );
  }

  Widget _buildUserInfo(
    BuildContext context,
    RenteeFeedbackViewModel viewModel,
    FeedbackModel feedback,
  ) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(feedback.renterId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return _buildDefaultUserInfo();
        }

        final userData = snapshot.data?.data() as Map<String, dynamic>? ?? {};
        final profilePhoto = userData['profilePhoto'];
        final imageProvider = viewModel.getImageProvider(profilePhoto);

        return Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[800],
              backgroundImage: imageProvider,
              child: imageProvider == null
                  ? Icon(Icons.person, color: Colors.grey[600])
                  : null,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userData['username'] ?? 'Anonymous User',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    feedback.pickupDate,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            _buildRatingStars(feedback.rating),
          ],
        );
      },
    );
  }

  Widget _buildDefaultUserInfo() {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey[800],
          child: Icon(Icons.person, color: Colors.grey[600]),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Anonymous User',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                'Loading...',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeedbackContent(FeedbackModel feedback) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: feedback.selectedFeedback.map((text) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildVehicleInfo(FeedbackModel feedback) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.yellow[700]!.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.directions_car,
            size: 16,
            color: Colors.yellow[700],
          ),
          SizedBox(width: 8),
          Text(
            feedback.vehicleName,
            style: TextStyle(
              fontSize: 14,
              color: Colors.yellow[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingStars(int rating) {
    return Row(
      children: List.generate(
        5,
        (index) => Icon(
          Icons.star,
          color: index < rating ? Colors.yellow[700] : Colors.grey[800],
          size: 20,
        ),
      ),
    );
  }
}