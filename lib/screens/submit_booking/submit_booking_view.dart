// lib/screens/submit_booking/submit_booking_view.dart
import 'package:flutter/material.dart';
import 'package:map_mvvm/view/view.dart';
import 'submit_booking_viewmodel.dart';
import '../../configs/constants.dart';

class SubmitBookingView extends StatelessWidget {
  final String vehicleId;
  final Map<String, String> bookingDetails;

  const SubmitBookingView({
    required this.vehicleId,
    required this.bookingDetails,
  });

  @override
  Widget build(BuildContext context) {
    return ViewWrapper<SubmitBookingViewModel>(
      builder: (context, viewModel) {
        // Load data when view is first built
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!viewModel.isLoaded) {
            viewModel.loadData(vehicleId);
          }
        });

        if (viewModel.isLoading) {
          return Scaffold(
            backgroundColor: AppTheme.backgroundBlack,
            body: Center(
              child: CircularProgressIndicator(color: AppTheme.primaryYellow),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppTheme.backgroundBlack,
          appBar: AppBar(
            backgroundColor: AppTheme.cardBlack,
            elevation: 0,
            title: Text(
              'Booking Details',
              style: TextStyle(
                color: AppTheme.primaryYellow,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailSection('Vehicle Details', viewModel.vehicleDetailsList),
                _buildDetailSection('Booking Details', viewModel.getBookingDetailsList(bookingDetails)),
                _buildDetailSection('User Details', viewModel.userDetailsList),
                SizedBox(height: 24),
                _buildActionButtons(context, viewModel),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailSection(String title, List<Map<String, dynamic>> details) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardBlack,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.cardBlack.withOpacity(0.8),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              border: Border(
                bottom: BorderSide(color: AppTheme.primaryYellow, width: 1),
              ),
            ),
            child: Text(
              title,
              style: TextStyle(
                color: AppTheme.primaryYellow,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: details.map((detail) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        detail['label']!,
                        style: TextStyle(
                          color: AppTheme.textGrey,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        detail['value']!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, SubmitBookingViewModel viewModel) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.pop(context),
            child: Text(
              'CANCEL',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryYellow,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => viewModel.submitBooking(
              context,
              vehicleId,
              bookingDetails,
            ),
            child: Text(
              'CONFIRM',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
