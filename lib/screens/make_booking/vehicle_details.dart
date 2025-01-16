import 'package:flutter/material.dart';
import '../../configs/constants.dart';

class VehicleDetails extends StatelessWidget {
  final Map<String, dynamic>? vehicleDetails;
  final bool isLoading;

  const VehicleDetails({
    Key? key,
    required this.vehicleDetails,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading || vehicleDetails == null) {
      return Center(
        child: CircularProgressIndicator(color: AppTheme.primaryYellow),
      );
    }

    return Container(
      color: AppTheme.backgroundBlack,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildVehicleImage(),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildVehicleTitle(),
                  SizedBox(height: 16),
                  _buildSpecificationsGrid(),
                  SizedBox(height: 20),
                  _buildPriceSection(),
                  SizedBox(height: 20),
                  _buildRenterDetailsCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleImage() {
    return Container(
      height: 200,
      width: double.infinity,
      child: Image.asset(
        'assets/images/${vehicleDetails!['vehicle_name'].toString().toLowerCase()}.png',
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Icon(
          Icons.directions_car,
          size: 100,
          color: AppTheme.primaryYellow,
        ),
      ),
    );
  }

  Widget _buildVehicleTitle() {
    return Text(
      vehicleDetails!['vehicle_name'] ?? '',
      style: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSpecificationsGrid() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 1.5,
      physics: NeverScrollableScrollPhysics(),
      children: _buildSpecifications(),
    );
  }

  List<Widget> _buildSpecifications() {
    final specs = _getVehicleSpecs();
    return specs.map((spec) => _buildSpecBox(spec['title']!, spec['value']!)).toList();
  }

  List<Map<String, String>> _getVehicleSpecs() {
    final vehicleType = vehicleDetails!['vehicle_type'];
    switch (vehicleType) {
      case 'Car':
        return [
          {'title': 'Transmission', 'value': vehicleDetails!['transmission_type']},
          {'title': 'Fuel', 'value': vehicleDetails!['fuel_type']},
          {'title': 'Seats', 'value': vehicleDetails!['seater_type']},
        ];
      case 'Motorcycle':
        return [
          {'title': 'Brand', 'value': vehicleDetails!['vehicle_brand']},
          {'title': 'Type', 'value': vehicleDetails!['motorcycle_type']},
          {'title': 'Model', 'value': vehicleDetails!['vehicle_model']},
        ];
      default:
        return [
          {'title': 'Type', 'value': vehicleType},
          {'title': 'Status', 'value': vehicleDetails!['availability']},
        ];
    }
  }

  Widget _buildSpecBox(String title, String value) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppTheme.cardBlack,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(color: AppTheme.textGrey, fontSize: 12),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection() {
    final hourlyRate = vehicleDetails!['price_per_hour'];
    final dayRate = hourlyRate * 24;
    final weekRate = dayRate * 7;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildRateBox('Day Rate', dayRate),
        _buildRateBox('Week Rate', weekRate),
      ],
    );
  }

  Widget _buildRateBox(String title, double amount) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.cardBlack,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: AppTheme.textGrey, fontSize: 12)),
            SizedBox(height: 4),
            Text(
              '\$${amount.toStringAsFixed(2)}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRenterDetailsCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBlack,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Renter Details',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          _buildRenterDetailRow('Name', vehicleDetails!['username']),
          _buildRenterDetailRow('Contact', vehicleDetails!['contact']),
          _buildRenterDetailRow('Email', vehicleDetails!['email']),
        ],
      ),
    );
  }

  Widget _buildRenterDetailRow(String label, String? value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: AppTheme.textGrey)),
          Text(value ?? 'N/A', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

class BookingPriceBar extends StatelessWidget {
  final double pricePerHour;
  final VoidCallback onBookNow;

  const BookingPriceBar({
    Key? key,
    required this.pricePerHour,
    required this.onBookNow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBlack,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Price per hour',
                style: TextStyle(color: AppTheme.textGrey),
              ),
              Text(
                '\$${pricePerHour.toStringAsFixed(2)}/hr',
                style: TextStyle(
                  color: AppTheme.primaryYellow,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: onBookNow,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryYellow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'Book Now',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}