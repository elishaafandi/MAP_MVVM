import 'package:flutter/material.dart';
import 'package:map_mvvm/view/view.dart';
import 'package:movease/models/booking_with_details.dart';
import 'booking_list_viewmodel.dart';
import '../../configs/constants.dart';

class BookingListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewWrapper<BookingListViewModel>(
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
      title: Text(
        'BOOKING LIST',
        style: TextStyle(
          color: AppTheme.primaryYellow,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
      elevation: 0,
    );
  }

  Widget _buildBody(BuildContext context, BookingListViewModel viewModel) {
    return StreamBuilder<List<BookingWithDetails>>(
      stream: viewModel.bookingsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(color: AppTheme.primaryYellow));
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error fetching bookings',
              style: TextStyle(color: AppTheme.mainWhite),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyState();
        }

        return _buildBookingsList(context, viewModel, snapshot.data!);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.car_rental, size: 64, color: AppTheme.primaryYellow),
          SizedBox(height: 16),
          Text(
            'No bookings found',
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
    BuildContext context,
    BookingListViewModel viewModel,
    List<BookingWithDetails> bookings,
  ) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      itemCount: bookings.length,
      itemBuilder: (context, index) => _buildBookingCard(
        context,
        viewModel,
        bookings[index],
      ),
    );
  }

  Widget _buildBookingCard(
    BuildContext context,
    BookingListViewModel viewModel,
    BookingWithDetails booking,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundBlack,
        border: Border.all(
          color: viewModel.getStatusColor(booking.status),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: viewModel.getStatusColor(booking.status).withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBookingHeader(context, viewModel, booking),
            SizedBox(height: 12),
            Text(
              booking.vehicleType,
              style: TextStyle(
                color: AppTheme.mainWhite.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
            SizedBox(height: 12),
            _buildBookingDates(booking),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingHeader(
    BuildContext context,
    BookingListViewModel viewModel,
    BookingWithDetails booking,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            booking.vehicleName,
            style: TextStyle(
              color: AppTheme.primaryYellow,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(
          children: [
            if (booking.status.toLowerCase() == 'pending')
              IconButton(
                icon: Icon(Icons.check_circle_outline, color: Colors.green),
                onPressed: () => viewModel.approveBooking(
                  context,
                  booking.bookingId,
                ),
                tooltip: 'Approve Booking',
              ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color:
                    viewModel.getStatusColor(booking.status).withOpacity(0.1),
                border: Border.all(
                  color: viewModel.getStatusColor(booking.status),
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    viewModel.getStatusEmoji(booking.status),
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(width: 4),
                  Text(
                    booking.status[0].toUpperCase() +
                        booking.status.substring(1).toLowerCase(),
                    style: TextStyle(
                      color: viewModel.getStatusColor(booking.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBookingDates(BookingWithDetails booking) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PICKUP',
                style: TextStyle(
                  color: AppTheme.mainWhite.withOpacity(0.5),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '${booking.pickupDate}\n${booking.pickupTime}',
                style: TextStyle(
                  color: AppTheme.mainWhite,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'RETURN',
                style: TextStyle(
                  color: AppTheme.mainWhite.withOpacity(0.5),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '${booking.returnDate}\n${booking.returnTime}',
                style: TextStyle(
                  color: AppTheme.mainWhite,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
