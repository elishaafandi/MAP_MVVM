import 'package:flutter/material.dart';
import 'package:map_mvvm/view/view.dart';
import 'package:movease/screens/pre_inspection_confirm/pre_inspection_confirm_viewmodel.dart';
//import 'package:movease/screens/renter_status_tracker.dart';

class PreInspectionConfirmView
    extends ViewWrapper<PreInspectionConfirmViewModel> {
  final Map<String, dynamic> bookingDetails;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  PreInspectionConfirmView({
    Key? key,
    required this.bookingDetails,
    required this.onConfirm,
    required this.onCancel,
  }) : super(
          showProgressIndicator: true,
        );

  @override
  PreInspectionConfirmViewModel viewModelBuilder(BuildContext context) {
    return PreInspectionConfirmViewModel(
      bookingDetails: bookingDetails,
      onConfirm: onConfirm,
      onCancel: onCancel,
    );
  }

  @override
  Widget builder(
      BuildContext context, PreInspectionConfirmViewModel viewModel) {
    if (viewModel.isLoading) {
      return _buildLoadingScaffold();
    }

    if (viewModel.inspectionFormDetails == null) {
      return _buildErrorScaffold();
    }

    return _buildMainScaffold(context, viewModel);
  }

  Widget _buildLoadingScaffold() {
    return Scaffold(
      backgroundColor: const Color(0xff1e1e1e),
      appBar: _buildAppBar(),
      body: const Center(
        child: CircularProgressIndicator(
          color: Colors.yellow,
        ),
      ),
    );
  }

  Widget _buildErrorScaffold() {
    return Scaffold(
      backgroundColor: const Color(0xff1e1e1e),
      appBar: _buildAppBar(),
      body: const Center(
        child: Text(
          'No inspection form found',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Inspection Form',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: Colors.white.withOpacity(0.05),
      iconTheme: const IconThemeData(color: Colors.white),
      elevation: 0,
    );
  }

  Widget _buildMainScaffold(
      BuildContext context, PreInspectionConfirmViewModel viewModel) {
    return Scaffold(
      backgroundColor: const Color(0xff1e1e1e),
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildHeader(),
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildVehicleInformationCard(viewModel),
                    const SizedBox(height: 20),
                    _buildInspectionDetailsCard(viewModel),
                    const SizedBox(height: 20),
                    _buildNotesCard(
                      'Additional Comments',
                      viewModel.inspectionFormDetails!.inspectionComments,
                    ),
                    const SizedBox(height: 100),
                  ]),
                ),
              ),
            ],
          ),
          _buildBottomButtons(context, viewModel),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.yellow.shade700,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Vehicle Inspection Report',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Inspection details submitted by rentee',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleInformationCard(PreInspectionConfirmViewModel viewModel) {
    final form = viewModel.inspectionFormDetails!;
    return _buildCard(
      'Vehicle Information',
      [
        _buildDetailRow(
          'Vehicle Name',
          form.vehicleName,
          Icons.directions_car,
        ),
        _buildDetailRow(
          'Vehicle ID',
          form.vehicleId,
          Icons.confirmation_number,
        ),
        _buildDetailRow(
          'Pickup Date',
          form.pickupDate,
          Icons.calendar_today,
        ),
        _buildDetailRow(
          'Return Date',
          form.returnDate,
          Icons.calendar_view_day,
        ),
        _buildDetailRow(
          'Price per Hour',
          'RM ${form.pricePerHour}',
          Icons.attach_money,
        ),
      ],
    );
  }

  Widget _buildInspectionDetailsCard(PreInspectionConfirmViewModel viewModel) {
    final form = viewModel.inspectionFormDetails!;
    return _buildCard(
      'Inspection Details',
      [
        _buildDetailRow(
          'Car Condition',
          form.carCondition,
          Icons.car_repair,
        ),
        _buildDetailRow(
          'Exterior Condition',
          form.exteriorCondition,
          Icons.car_crash,
        ),
        _buildDetailRow(
          'Interior Condition',
          form.interiorCondition,
          Icons.airline_seat_recline_normal,
        ),
        _buildDetailRow(
          'Tires',
          form.tires,
          Icons.tire_repair,
        ),
        _buildDetailRow(
          'Fuel Level',
          form.fuelLevel,
          Icons.local_gas_station,
        ),
        _buildDetailRow(
          'Lights and Signals',
          form.lightsAndSignals,
          Icons.light,
        ),
        _buildDetailRow(
          'Engine Sound',
          form.engineSound,
          Icons.engineering,
        ),
        _buildDetailRow(
          'Brakes',
          form.brakes,
          Icons.warning,
        ),
      ],
    );
  }

  Widget _buildCard(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.yellow.shade700,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesCard(String title, String notes) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.note_alt_outlined,
                color: Colors.yellow.shade700,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            notes,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(
      BuildContext context, PreInspectionConfirmViewModel viewModel) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xff1e1e1e),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: viewModel.onCancel,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () => viewModel.confirmInspection(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Confirm',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
