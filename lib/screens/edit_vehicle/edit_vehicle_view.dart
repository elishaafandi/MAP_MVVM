import 'package:flutter/material.dart';
import 'package:map_mvvm/view/view.dart';
import 'edit_vehicle_viewmodel.dart';

class EditVehicleView extends StatelessWidget {
  final EditVehicleViewModel viewModel;
  final Map<String, dynamic> vehicle;

  const EditVehicleView({
    Key? key,
    required this.viewModel,
    required this.vehicle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2A2A2A),
      appBar: _buildAppBar(vehicle['type']),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(vehicle['type']),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                child: _buildFormContent(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(String vehicleType) {
    return AppBar(
      title: Text(
        'Edit $vehicleType',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      backgroundColor: Colors.yellow[700],
      elevation: 0,
    );
  }

  Widget _buildHeader(String vehicleType) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/renter.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.4),
              Colors.black.withOpacity(0.7),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.edit_road, size: 60, color: Colors.yellow[700]),
            SizedBox(height: 16),
            Text(
              'Edit Your $vehicleType',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormContent(BuildContext context) {
    return Column(
      children: [
        if (viewModel.errorMessage.isNotEmpty)
          Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red),
            ),
            child: Text(
              viewModel.errorMessage,
              style: TextStyle(color: Colors.red),
            ),
          ),
        _buildSection(
          icon: Icons.directions_car,
          title: 'Vehicle Details',
          children: [
            _buildTextField(
              label: 'Vehicle Name',
              hint: 'Enter vehicle name',
              initialValue: viewModel.vehicleName,
              icon: Icons.drive_file_rename_outline,
              onChanged: viewModel.updateVehicleName,
            ),
          ],
        ),
        SizedBox(height: 24),
        
        if (viewModel.vehicleType.toLowerCase() == 'car' ||
            viewModel.vehicleType.toLowerCase() == 'motorcycle')
          _buildVehicleDetailsSection(viewModel),
        
        if (viewModel.vehicleType.toLowerCase() == 'car')
          _buildCarSpecificationsSection(viewModel)
        else if (viewModel.vehicleType.toLowerCase() == 'motorcycle')
          _buildMotorcycleTypeSection(viewModel)
        else if (viewModel.vehicleType.toLowerCase() == 'scooter')
          _buildScooterTypeSection(viewModel)
        else if (viewModel.vehicleType.toLowerCase() == 'bicycle')
          _buildBicycleTypeSection(viewModel),

        SizedBox(height: 24),
        _buildPricingSection(viewModel),
        SizedBox(height: 24),
        _buildAvailabilitySection(viewModel),
        SizedBox(height: 32),
        _buildSaveButton(context, viewModel),
        SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF3A3A3A),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.yellow[700]!.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.yellow[700], size: 24),
              ),
              SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required String initialValue,
    required IconData icon,
    required Function(String) onChanged,
  }) {
    return TextFormField(
      initialValue: initialValue,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.yellow[700]),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400]),
        prefixIcon: Icon(icon, color: Colors.yellow[700]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.yellow[700]!.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.yellow[700]!.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.yellow[700]!),
        ),
        filled: true,
        fillColor: Color(0xFF2A2A2A),
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildVehicleDetailsSection(EditVehicleViewModel viewModel) {
    return Column(
      children: [
        _buildSection(
          icon: Icons.info,
          title: 'Vehicle Information',
          children: [
            _buildTextField(
              label: 'Brand',
              hint: 'Enter brand',
              initialValue: viewModel.vehicleBrand,
              icon: Icons.branding_watermark,
              onChanged: viewModel.updateVehicleBrand,
            ),
            SizedBox(height: 16),
            _buildTextField(
              label: 'Model',
              hint: 'Enter model',
              initialValue: viewModel.vehicleModel,
              icon: Icons.model_training,
              onChanged: viewModel.updateVehicleModel,
            ),
            SizedBox(height: 16),
            _buildTextField(
              label: 'Plate Number',
              hint: 'Enter plate number',
              initialValue: viewModel.plateNo,
              icon: Icons.credit_card,
              onChanged: viewModel.updatePlateNo,
            ),
          ],
        ),
        SizedBox(height: 24),
      ],
    );
  }

  Widget _buildCarSpecificationsSection(EditVehicleViewModel viewModel) {
    return _buildSection(
      icon: Icons.settings,
      title: 'Car Specifications',
      children: [
        _buildChipSection(
          icon: Icons.settings_applications,
          title: 'Transmission',
          options: ['Manual', 'Automatic'],
          selectedValue: viewModel.transmissionType,
          onSelected: viewModel.updateTransmissionType,
        ),
        SizedBox(height: 20),
        _buildChipSection(
          icon: Icons.local_gas_station,
          title: 'Fuel Type',
          options: ['Petrol', 'Diesel', 'Electric', 'Hybrid'],
          selectedValue: viewModel.fuelType,
          onSelected: viewModel.updateFuelType,
        ),
        SizedBox(height: 20),
        _buildChipSection(
          icon: Icons.airline_seat_recline_normal,
          title: 'Seater Type',
          options: ['2', '4', '5', '7', '8'],
          selectedValue: viewModel.seaterType,
          onSelected: viewModel.updateSeaterType,
        ),
      ],
    );
  }

  Widget _buildMotorcycleTypeSection(EditVehicleViewModel viewModel) {
    return _buildSection(
      icon: Icons.motorcycle,
      title: 'Motorcycle Type',
      children: [
        _buildChipSection(
          icon: Icons.two_wheeler,
          title: 'Type',
          options: ['Standard', 'Sport', 'Cruiser', 'Off-road'],
          selectedValue: viewModel.motorcycleType,
          onSelected: viewModel.updateMotorcycleType,
        ),
      ],
    );
  }

  Widget _buildScooterTypeSection(EditVehicleViewModel viewModel) {
    return _buildSection(
      icon: Icons.electric_scooter,
      title: 'Scooter Type',
      children: [
        _buildChipSection(
          icon: Icons.electric_moped,
          title: 'Type',
          options: ['Electric', 'Kick', 'Gas'],
          selectedValue: viewModel.scooterType,
          onSelected: viewModel.updateScooterType,
        ),
      ],
    );
  }

  Widget _buildBicycleTypeSection(EditVehicleViewModel viewModel) {
    return _buildSection(
      icon: Icons.pedal_bike,
      title: 'Bicycle Type',
      children: [
        _buildChipSection(
          icon: Icons.directions_bike,
          title: 'Type',
          options: ['Mountain', 'Road', 'Hybrid', 'Electric'],
          selectedValue: viewModel.bicycleType,
          onSelected: viewModel.updateBicycleType,
        ),
      ],
    );
  }

  Widget _buildPricingSection(EditVehicleViewModel viewModel) {
    return _buildSection(
      icon: Icons.attach_money,
      title: 'Pricing',
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Price per Hour',
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.yellow[700],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'RM ${viewModel.pricePerHour.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: Colors.yellow[700],
                inactiveTrackColor: Colors.grey[800],
                thumbColor: Colors.yellow[700],
                overlayColor: Colors.yellow[700]!.withOpacity(0.2),
                valueIndicatorColor: Colors.yellow[700],
                valueIndicatorTextStyle: TextStyle(color: Colors.black),
              ),
              child: Slider(
                value: viewModel.pricePerHour.clamp(5.0, 30.0),
                min: 5.0,
                max: 30.0,
                divisions: 25,
                label: 'RM ${viewModel.pricePerHour.toStringAsFixed(2)}',
                onChanged: viewModel.updatePricePerHour,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAvailabilitySection(EditVehicleViewModel viewModel) {
    return _buildSection(
      icon: Icons.check_circle,
      title: 'Availability',
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 20,
                  color: Colors.yellow[700],
                ),
                SizedBox(width: 8),
                Text(
                  'Available for Rent',
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Switch(
              value: viewModel.availability,
              onChanged: viewModel.updateAvailability,
              activeColor: Colors.yellow[700],
              inactiveTrackColor: Colors.grey[800],
              trackColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.yellow[700]!.withOpacity(0.5);
                }
                return Colors.grey[800];
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChipSection({
    required IconData icon,
    required String title,
    required List<String> options,
    required String selectedValue,
    required void Function(String) onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.yellow[700]),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 16,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = selectedValue == option;
            return FilterChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (_) => onSelected(option),
              backgroundColor: Color(0xFF2A2A2A),
              selectedColor: Colors.yellow[700],
              checkmarkColor: Colors.black,
              labelStyle: TextStyle(
                color: isSelected ? Colors.black : Colors.grey[300],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context, EditVehicleViewModel viewModel) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () async {
          if (await viewModel.saveVehicle()) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Vehicle updated successfully'),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
            Navigator.pop(context);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.yellow[700],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: const Text(
          'Save Changes',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}