import 'package:flutter/material.dart';
import 'package:map_mvvm/view/view.dart';
import 'package:movease/configs/constants.dart';
import 'package:movease/screens/booking_status_renter/booking_status_renter_viewm';

class BookingStatusRenterView extends StatelessWidget {
  const BookingStatusRenterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewWrapper<BookingStatusRenterViewModel>(
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
      backgroundColor: AppTheme.backgroundBlack,
      title: const Text(
        'RENTER BOOKINGS',
        style: TextStyle(
          color: AppTheme.primaryYellow,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
      elevation: 0,
    );
  }

  Widget _buildBody(
      BuildContext context, BookingStatusRenterViewModel viewModel) {
    if (viewModel.error != null) {
      return Center(
        child: Text(
          'Error fetching bookings',
          style: TextStyle(color: AppTheme.mainWhite),
        ),
      );
    }

    if (viewModel.bookings.isEmpty) {
      return _buildEmptyState();
    }

    return _buildBookingsList(context, viewModel);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.car_rental, size: 64, color: AppTheme.primaryYellow),
          SizedBox(height: 16),
          Text(
            'No approved bookings found',
            style: TextStyle(
              color: AppTheme.mainWhite,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsList(
      BuildContext context, BookingStatusRenterViewModel viewModel) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      itemCount: viewModel.bookings.length,
      itemBuilder: (context, index) {
        final booking = viewModel.bookings[index];
        return _buildBookingCard(context, viewModel, booking);
      },
    );
  }

  Widget _buildBookingCard(
    BuildContext context,
    BookingStatusRenterViewModel viewModel,
    Map<String, dynamic> booking,
  ) {
    final currentStatus = booking['current_status'] ?? 'booking confirmed';
    final statusColor = viewModel.getCurrentStatusColor(currentStatus);

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundBlack,
        border: Border.all(
          color: statusColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/renter-status',
              arguments: {
                ...booking,
                'name': booking['vehicleDetails']['vehicle_name'] ??
                    'Unknown Vehicle',
                'plateNo':
                    booking['vehicleDetails']['plate_number'] ?? 'No Plate',
                'pricePerHour':
                    booking['vehicleDetails']['price_per_hour'] ?? 0.0,
              },
            );
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBookingHeader(viewModel, booking, currentStatus),
                SizedBox(height: 12),
                _buildVehicleInfo(booking),
                SizedBox(height: 8),
                _buildLocationInfo(booking),
                SizedBox(height: 12),
                _buildBookingDates(booking),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookingHeader(
    BookingStatusRenterViewModel viewModel,
    Map<String, dynamic> booking,
    String currentStatus,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            booking['vehicleName'],
            style: TextStyle(
              color: AppTheme.primaryYellow,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _buildStatusBadge(viewModel, currentStatus),
      ],
    );
  }

  Widget _buildStatusBadge(
    BookingStatusRenterViewModel viewModel,
    String currentStatus,
  ) {
    final statusColor = viewModel.getCurrentStatusColor(currentStatus);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        border: Border.all(color: statusColor),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            viewModel.getCurrentStatusEmoji(currentStatus),
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(width: 4),
          Text(
            currentStatus[0].toUpperCase() +
                currentStatus.substring(1).toLowerCase(),
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleInfo(Map<String, dynamic> booking) {
    return Text(
      booking['vehicleType'] ?? 'Unknown Type',
      style: TextStyle(
        color: AppTheme.mainWhite.withOpacity(0.7),
        fontSize: 14,
      ),
    );
  }

  Widget _buildLocationInfo(Map<String, dynamic> booking) {
    return Row(
      children: [
        Icon(
          Icons.location_on,
          color: AppTheme.primaryYellow,
          size: 16,
        ),
        SizedBox(width: 4),
        Text(
          booking['location'] ?? 'Unknown Location',
          style: TextStyle(
            color: AppTheme.mainWhite,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildBookingDates(Map<String, dynamic> booking) {
    return Row(
      children: [
        Expanded(
          child: _buildDateColumn(
            'PICKUP',
            booking['pickupDate'] ?? 'Not set',
            booking['pickupTime'] ?? 'Time not set',
          ),
        ),
        Expanded(
          child: _buildDateColumn(
            'RETURN',
            booking['returnDate'] ?? 'Not set',
            booking['returnTime'] ?? 'Time not set',
          ),
        ),
      ],
    );
  }

  Widget _buildDateColumn(String label, String date, String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppTheme.mainWhite.withOpacity(0.5),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          '$date\n$time',
          style: TextStyle(
            color: AppTheme.mainWhite,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
