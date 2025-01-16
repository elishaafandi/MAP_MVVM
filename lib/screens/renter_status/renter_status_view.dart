import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:map_mvvm/view/view.dart';
import 'package:movease/configs/constants.dart';
import 'package:movease/models/booking_with_details.dart';
import 'package:movease/rental_status_handler.dart';
import 'renter_status_viewmodel.dart';
import 'booking_details_card.dart';
import 'status_step_card.dart';

class RenterStatusView extends StatelessWidget {
  final Map<String, dynamic> bookingDetails;
  final RenterStatusViewModel viewModel;

  const RenterStatusView({
    required this.bookingDetails,
    required this.viewModel,
    super.key,
  });

  Map<String, dynamic> _bookingToMap(BookingWithDetails? booking) {
    if (booking == null) return {};
    return {
      'name': booking.vehicleName,
      'plateNo': booking.vehicleId,
      'pricePerHour': booking.pricePerHour,
      'pickupDate': booking.pickupDate,
      'pickupTime': booking.pickupTime,
      'returnDate': booking.returnDate,
      'returnTime': booking.returnTime,
      'location': booking.location,
      'bookingId': booking.bookingId,
      'renteeStatus': booking.renteeStatus,
      'renterStatus': booking.renterStatus,
    };
  }

  Future<void> _handleStatusUpdate(BuildContext context, String action) async {
    final booking = viewModel.currentBookingDetails;
    if (booking == null) return;

    try {
      
      await RentalStatusHandler.updateStatus(
        bookingId: booking.bookingId,
        action: action,
        currentRenterStatus: booking.renterStatus,
        currentRenteeStatus: booking.renteeStatus,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Status updated successfully'),
          backgroundColor: AppTheme.successGreen,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update status: $e'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final booking = BookingWithDetails.fromMap(
      bookingDetails,
      bookingDetails['bookingId'] ?? '',
    );

    viewModel.setInitialBooking(booking);

    return Scaffold(
      backgroundColor: AppTheme.backgroundBlack,
      appBar: _buildAppBar(context),
      body: viewModel.isLoading
          ? _buildLoadingIndicator()
          : _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          BookingDetailsWidget(
            bookingDetails: _bookingToMap(viewModel.currentBookingDetails),
          ),
          StatusStepsWidget(
            steps: viewModel.statusSteps,
            onStatusUpdate: (action) => _handleStatusUpdate(context, action),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.backgroundBlack,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppTheme.mainWhite),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'RENTER STATUS',
        style: TextStyle(
          color: AppTheme.primaryYellow,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(
        color: AppTheme.primaryYellow,
      ),
    );
  }
}
