import 'package:flutter/material.dart';
import 'package:map_mvvm/view/view.dart';
import 'booking_request_viewmodel.dart';
import '../../configs/constants.dart';

class BookingRequestView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewWrapper<BookingRequestViewModel>(
      builder: (context, viewModel) {
        return Scaffold(
          backgroundColor: AppTheme.backgroundBlack,
          appBar: AppBar(
            backgroundColor: AppTheme.backgroundBlack,
            title: Text(
              'Booking List',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: Column(
            children: [
              _buildStatusFilters(viewModel),
              Expanded(
                child: _buildBookingsList(context, viewModel),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusFilters(BookingRequestViewModel viewModel) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildStatusFilter('All', viewModel),
          SizedBox(width: 8),
          _buildStatusFilter('Pending', viewModel),
          SizedBox(width: 8),
          _buildStatusFilter('Approved', viewModel),
          SizedBox(width: 8),
          _buildStatusFilter('Rejected', viewModel),
          SizedBox(width: 8),
          _buildStatusFilter('Cancelled', viewModel),
        ],
      ),
    );
  }

  Widget _buildStatusFilter(String status, BookingRequestViewModel viewModel) {
    final isSelected = viewModel.selectedStatus == status;
    return GestureDetector(
      onTap: () => viewModel.setStatus(status),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryYellow : Colors.grey[800],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          status,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildBookingsList(BuildContext context, BookingRequestViewModel viewModel) {
    if (viewModel.isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryYellow),
        ),
      );
    }

    if (viewModel.bookings.isEmpty) {
      return Center(
        child: Text(
          'No bookings found',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: viewModel.bookings.length,
      itemBuilder: (context, index) {
        final booking = viewModel.bookings[index];
        return _buildBookingCard(booking, viewModel);
      },
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking, BookingRequestViewModel viewModel) {
    final status = (booking['booking_status'] ?? '').toString().toLowerCase();
    final isPending = status == 'pending';

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.cardBlack,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking['vehicleName'] ?? 'Unknown Vehicle',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        booking['plateNumber'] ?? 'No plate number',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(status),
              ],
            ),
            if (isPending) ...[
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildActionButton(
                    'Accept',
                    AppTheme.successGreen,
                    () => viewModel.updateBookingStatus(booking['bookingId'], 'approved'),
                  ),
                  SizedBox(width: 12),
                  _buildActionButton(
                    'Reject',
                    Colors.red,
                    () => viewModel.updateBookingStatus(booking['bookingId'], 'rejected'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor(status),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return AppTheme.successGreen;
      case 'rejected':
        return Colors.red;
      case 'cancelled':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  Widget _buildActionButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}