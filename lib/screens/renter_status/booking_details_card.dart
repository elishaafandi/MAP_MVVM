import 'package:flutter/material.dart';
import 'package:movease/configs/constants.dart';
import 'package:movease/rental_constants.dart';

class BookingDetailsWidget extends StatelessWidget {
  final Map<String, dynamic> bookingDetails;

  const BookingDetailsWidget({
    required this.bookingDetails,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBlack,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[850]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${bookingDetails['name']} (${bookingDetails['plateNo']})',
            style: TextStyle(
              color: AppTheme.mainWhite,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          if (bookingDetails['pricePerHour'] != null)
            Text(
              'Price per Hour: RM${(bookingDetails['pricePerHour'] ?? 0.0).toStringAsFixed(2)}',
              style: TextStyle(color: AppTheme.mainWhite),
            ),
          SizedBox(height: 12),
          Text(
            'Pickup: ${RentalUtils.formatDate(bookingDetails['pickupDate'])} ${bookingDetails['pickupTime']}',
            style: TextStyle(color: AppTheme.mainWhite),
          ),
          Text(
            'Return: ${RentalUtils.formatDate(bookingDetails['returnDate'])} ${bookingDetails['returnTime']}',
            style: TextStyle(color: AppTheme.mainWhite),
          ),
          Text(
            'Location: ${bookingDetails['location']}',
            style: TextStyle(color: AppTheme.mainWhite),
          ),
        ],
      ),
    );
  }
}