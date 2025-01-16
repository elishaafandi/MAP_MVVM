// lib/screens/pay_deposit/pay_deposit_view.dart
import 'package:flutter/material.dart';
import 'package:map_mvvm/view/view.dart';
import 'package:movease/configs/service_locator.dart';
import 'package:movease/models/booking_with_details.dart';
import 'pay_deposit_viewmodel.dart';
import '../../configs/constants.dart';

class PayDepositView extends StatelessWidget {
  final BookingWithDetails booking;

  const PayDepositView({
    Key? key,
    required this.booking,
  }) : super(key: key);

 @override
  Widget build(BuildContext context) {
    return ViewWrapper<PayDepositViewModel>(
      showProgressIndicator: true,
      builder: (context, viewModel) {
        return Scaffold(
          backgroundColor: AppTheme.backgroundBlack,
          appBar: _buildAppBar(),
          body: _buildBody(context, viewModel),
        );
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'Pay Deposit',
        style: TextStyle(color: AppTheme.backgroundBlack),
      ),
      backgroundColor: AppTheme.primaryYellow,
      iconTheme: IconThemeData(color: AppTheme.backgroundBlack),
    );
  }

  Widget _buildBody(BuildContext context, PayDepositViewModel viewModel) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildBookingDetails(viewModel),
            const SizedBox(height: 16),
            _buildPriceBreakdown(viewModel),
            const SizedBox(height: 16),
            _buildPaymentMethod(context, viewModel),
            const SizedBox(height: 24),
            _buildActionButtons(context, viewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingDetails(PayDepositViewModel viewModel) {
    final carDetails = viewModel.carDetails;
    return Card(
      color: AppTheme.cardBlack,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booking Details',
              style: TextStyle(
                color: AppTheme.primaryYellow,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Car', carDetails["car"] as String),
            _buildDetailRow('Plate Number', carDetails["plateNumber"] as String),
            _buildDetailRow('Booking Period', carDetails["bookingPeriod"] as String),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceBreakdown(PayDepositViewModel viewModel) {
    final breakdown = viewModel.getPriceBreakdown();
    return Card(
      color: AppTheme.cardBlack,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Price Breakdown',
              style: TextStyle(
                color: AppTheme.primaryYellow,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Total Rental Price', 'RM ${breakdown.totalPrice.toStringAsFixed(2)}'),
            Divider(color: AppTheme.primaryYellow),
            _buildDetailRow(
              'Required Deposit (35%)',
              'RM ${breakdown.deposit.toStringAsFixed(2)}',
              isBold: true,
              highlightColor: AppTheme.primaryYellow,
            ),
            _buildDetailRow(
              'Remaining Balance',
              'RM ${breakdown.remaining.toStringAsFixed(2)}',
              isSecondary: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethod(BuildContext context, PayDepositViewModel viewModel) {
    return Card(
      color: AppTheme.cardBlack,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Method',
              style: TextStyle(
                color: AppTheme.primaryYellow,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.primaryYellow),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String>(
                value: viewModel.selectedPaymentMethod,
                isExpanded: true,
                dropdownColor: AppTheme.cardBlack,
                style: const TextStyle(color: Colors.white),
                underline: Container(),
                items: viewModel.paymentMethods.map((String method) {
                  return DropdownMenuItem<String>(
                    value: method,
                    child: Text(method),
                  );
                }).toList(),
                onChanged: viewModel.updatePaymentMethod,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, PayDepositViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryYellow,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () => viewModel.proceedPayment(context),
              child: Text(
                'Pay Deposit',
                style: TextStyle(
                  color: AppTheme.backgroundBlack,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.cardBlack,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () => viewModel.cancelPayment(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value,
      {bool isBold = false, bool isSecondary = false, Color? highlightColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isSecondary ? AppTheme.textGrey : Colors.white,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: highlightColor ?? (isSecondary ? AppTheme.textGrey : Colors.white),
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}