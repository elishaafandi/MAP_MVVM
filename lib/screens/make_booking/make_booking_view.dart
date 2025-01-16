import 'package:flutter/material.dart';
import 'package:map_mvvm/view/view.dart';
import 'make_booking_viewmodel.dart';
import '../../configs/constants.dart';
import 'booking_form.dart';
import 'vehicle_details.dart';

class MakeBookingView extends StatefulWidget {
  final String vehicleId;

  const MakeBookingView({
    Key? key,
    required this.vehicleId,
  }) : super(key: key);

  @override
  _MakeBookingViewState createState() => _MakeBookingViewState();
}

class _MakeBookingViewState extends State<MakeBookingView> {
  @override
  Widget build(BuildContext context) {
    return ViewWrapper<MakeBookingViewModel>(
      builder: (context, viewModel) {
        // Call fetchVehicleDetails when the widget is first built
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (viewModel.vehicleDetails == null && !viewModel.isLoading) {
            viewModel.fetchVehicleDetails(widget.vehicleId);
          }
        });

        return Scaffold(
          backgroundColor: AppTheme.backgroundBlack,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: AppTheme.primaryYellow),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'Book Vehicle',
              style: TextStyle(
                color: AppTheme.primaryYellow,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            backgroundColor: AppTheme.cardBlack,
            elevation: 0,
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    VehicleDetails(
                      vehicleDetails: viewModel.vehicleDetails,
                      isLoading: viewModel.isLoading,
                    ),
                    SizedBox(height: 80),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: BookingPriceBar(
                  pricePerHour:
                      viewModel.vehicleDetails?['price_per_hour'] ?? 0.0,
                  onBookNow: () => _showBookingForm(context, viewModel),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showBookingForm(BuildContext context, MakeBookingViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.backgroundBlack,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (_, controller) => BookingForm(
          viewModel: viewModel,
          vehicleId: widget.vehicleId,
        ),
      ),
    );
  }
}
