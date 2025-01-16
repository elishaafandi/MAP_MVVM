import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:map_mvvm/view/view.dart';
import 'package:movease/car_delivery_rentee.dart';
import 'package:movease/configs/constants.dart';
import 'package:movease/final_payment.dart';
import 'package:movease/models/booking_with_details.dart';
import 'package:movease/pay_deposit.dart';
import 'package:movease/post_inspection_confirm.dart';
import 'package:movease/pre_inspection_form.dart';
import 'package:movease/rental_status_handler.dart';
import 'package:movease/write_feedback_formrentee.dart';
import 'rentee_status_viewmodel.dart';
import 'booking_details_card.dart';
import 'status_step_card.dart';

class RenteeStatusView extends StatelessWidget {
  final Map<String, dynamic> bookingDetails;
  final RenteeStatusViewModel viewModel;

  const RenteeStatusView({
    required this.bookingDetails,
    required this.viewModel,
    super.key,
  });

  Map<String, dynamic> _bookingToMap(BookingWithDetails? booking) {
    if (booking == null) return {};

    return {
      'name': booking.vehicleName,
      'plateNo': booking.plateNo,
      'pricePerHour': booking.pricePerHour,
      'pickupDate': booking.pickupDate,
      'pickupTime': booking.pickupTime,
      'returnDate': booking.returnDate,
      'returnTime': booking.returnTime,
      'location': booking.location,
      'bookingId': booking.bookingId,
      'renteeStatus': booking.renteeStatus,
      'renterStatus': booking.renterStatus,
      'vehicleId': booking.vehicleId,
      'vehicleName': booking.vehicleName,
      'plateNumber': booking.plateNo,
      'totalPrice': booking.calculateTotalPrice,
    };
  }

  Future<void> handleStatusUpdate(BuildContext context, String action) async {
    final booking = viewModel.currentBookingDetails;
    if (booking == null) return;

    try {
      viewModel.isLoading = true; // Direct assignment instead of setLoading()

      switch (action) {
        case 'MAKE_DEPOSIT_PAYMENT':
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PayDepositPage(
                bookingDetails: _bookingToMap(booking),
              ),
            ),
          );

          if (result == true) {
            await _updateStatusAndShowMessage(
              context,
              booking,
              action,
              'Deposit payment completed successfully',
            );
          }
          break;

        case 'CONFIRM_DELIVERY':
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewDeliveryRentee(
                bookingId: booking.bookingId,
                bookingDetails: _bookingToMap(booking),
              ),
            ),
          );

          if (result == true) {
            await _updateStatusAndShowMessage(
              context,
              booking,
              action,
              'Delivery status confirmed successfully',
            );
          }
          break;

        case 'FILL_PRE_INSPECTION':
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PreInspectionForm(
                bookingId: booking.bookingId,
                bookingDetails: _bookingToMap(booking),
              ),
            ),
          );

          if (result == true) {
            await _updateStatusAndShowMessage(
              context,
              booking,
              action,
              'Pre-inspection form submitted successfully',
            );
          }
          break;

        case 'CONFIRM_POST_INSPECTION':
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PostInspectionConfirmation(
                bookingDetails: _bookingToMap(booking),
                onConfirm: () async {
                  await RentalStatusHandler.updateStatus(
                    bookingId: booking.bookingId,
                    action: action,
                    currentRenterStatus: booking.renterStatus,
                    currentRenteeStatus: booking.renteeStatus,
                  );
                  Navigator.pop(context, true);
                },
                onCancel: () {
                  Navigator.pop(context, false);
                },
              ),
            ),
          );

          if (result == true) {
            _showSuccessMessage(context, 'Post-inspection confirmed');
          }
          break;

        case 'MAKE_FINAL_PAYMENT':
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FinalPaymentPage(
                bookingDetails: _bookingToMap(booking),
              ),
            ),
          );

          if (result == true) {
            await _updateStatusAndShowMessage(
              context,
              booking,
              action,
              'Final payment completed successfully',
            );
          }
          break;

        case 'START_USING':
          await _updateStatusAndShowMessage(
            context,
            booking,
            action,
            'Vehicle usage started',
          );
          break;

        case 'REQUEST_RETURN':
          await _updateStatusAndShowMessage(
            context,
            booking,
            action,
            'Return request submitted',
          );
          break;

        case 'RENTER_RATE_COMPLETED':
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WriteYourFeedback(
                bookingDetails: _bookingToMap(booking),
              ),
            ),
          );

          if (result == true) {
            await _updateStatusAndShowMessage(
              context,
              booking,
              action,
              'Rating submitted successfully',
            );
          }
          break;
      }
    } catch (e) {
      print('Error in handleStatusUpdate: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update status: ${e.toString()}'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
    } finally {
      viewModel.isLoading = false; // Direct assignment
    }
  }

  Future<void> _updateStatusAndShowMessage(
    BuildContext context,
    BookingWithDetails booking,
    String action,
    String message,
  ) async {
    await RentalStatusHandler.updateStatus(
      bookingId: booking.bookingId,
      action: action,
      currentRenterStatus: booking.renterStatus,
      currentRenteeStatus: booking.renteeStatus,
    );
    _showSuccessMessage(context, message);
  }

  void _showSuccessMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.successGreen,
      ),
    );
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
            onStatusUpdate: (action) => handleStatusUpdate(context, action),
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
        'RENTAL STATUS',
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
