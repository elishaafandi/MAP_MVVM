import 'package:flutter/material.dart';
import 'package:map_mvvm/view/view.dart';
import 'package:movease/screens/pre_inspection/pre_inspection_form_viewmodel.dart';

class PreInspectionFormView extends StatelessWidget {
  final String bookingId;
  final Map<String, dynamic> bookingDetails;

  // Define constant colors
  static const mainBlack = Color(0xFF000000);
  static const mainYellow = Color(0xFFFFD700);
  static const mainWhite = Color(0xFFFFFFFF);
  static const cardBackground = Color(0xFF1A1A1A);
  static const textGrey = Color(0xFF9E9E9E);

  const PreInspectionFormView({
    Key? key,
    required this.bookingId,
    required this.bookingDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewWrapper<PreInspectionFormViewModel>(
      builder: (context, viewModel) {
        return WillPopScope(
          onWillPop: () => _onWillPop(context, viewModel),
          child: Scaffold(
            backgroundColor: mainBlack,
            appBar: _buildAppBar(),
            body: Stack(
              children: [
                _buildMainContent(context, viewModel),
                if (viewModel.busy)
                  Container(
                    color: Colors.black87,
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(mainYellow),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'PRE-INSPECTION FORM',
        style: TextStyle(
          color: mainYellow,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
      backgroundColor: mainBlack,
      elevation: 0,
      iconTheme: const IconThemeData(color: mainWhite),
    );
  }

  Widget _buildMainContent(
      BuildContext context, PreInspectionFormViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: viewModel.formKey,
        child: ListView(
          children: [
            _buildVehicleInfoCard(),
            const SizedBox(height: 24),
            _buildInspectionSection(viewModel),
            const SizedBox(height: 24),
            _buildConditionChecklist(viewModel),
            const SizedBox(height: 32),
            _buildSubmitButton(context, viewModel),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleInfoCard() {
    return Container(
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: mainYellow.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: mainYellow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Vehicle Information',
            style: TextStyle(
              color: mainYellow,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          Divider(color: mainYellow.withOpacity(0.2), height: 24),
          _buildInfoRow('Vehicle ID', bookingDetails['vehicleId']),
          _buildInfoRow('Vehicle Name', bookingDetails['name']),
          _buildInfoRow('Price/Hour',
              'RM${bookingDetails['pricePerHour'].toStringAsFixed(2)}'),
          _buildInfoRow('Pickup', bookingDetails['pickupDate']),
          _buildInfoRow('Return', bookingDetails['returnDate']),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: textGrey,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: mainWhite,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInspectionSection(PreInspectionFormViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'General Inspection',
          style: TextStyle(
            color: mainYellow,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          label: 'Car Condition',
          initialValue: viewModel.carCondition,
          onSaved: (value) => viewModel.carCondition = value ?? '',
          icon: Icons.directions_car,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          label: 'Inspection Comments',
          initialValue: viewModel.inspectionComments,
          onSaved: (value) => viewModel.inspectionComments = value ?? '',
          icon: Icons.comment,
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildConditionChecklist(PreInspectionFormViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Condition Checklist',
          style: TextStyle(
            color: mainYellow,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 16),
        _buildDropdownField(
          label: 'Exterior Condition',
          items: ['Good', 'Not Good'],
          value: viewModel.dropdownSelections['Exterior Condition'],
          onChanged: (value) =>
              viewModel.updateDropdownSelection('Exterior Condition', value),
          icon: Icons.car_repair,
        ),
        const SizedBox(height: 12),
        _buildDropdownField(
          label: 'Tires',
          items: ['Good', 'Not Good'],
          value: viewModel.dropdownSelections['Tires'],
          onChanged: (value) =>
              viewModel.updateDropdownSelection('Tires', value),
          icon: Icons.tire_repair,
        ),
        const SizedBox(height: 12),
        _buildDropdownField(
          label: 'Interior Condition',
          items: ['Good', 'Not Good'],
          value: viewModel.dropdownSelections['Interior Condition'],
          onChanged: (value) =>
              viewModel.updateDropdownSelection('Interior Condition', value),
          icon: Icons.airline_seat_recline_normal,
        ),
        const SizedBox(height: 12),
        _buildDropdownField(
          label: 'Fuel Level',
          items: ['Full', '¾', '½', '¼', 'Empty'],
          value: viewModel.dropdownSelections['Fuel Level'],
          onChanged: (value) =>
              viewModel.updateDropdownSelection('Fuel Level', value),
          icon: Icons.local_gas_station,
        ),
        const SizedBox(height: 12),
        _buildDropdownField(
          label: 'Lights and Signals',
          items: ['Good', 'Not Good'],
          value: viewModel.dropdownSelections['Lights and Signals'],
          onChanged: (value) =>
              viewModel.updateDropdownSelection('Lights and Signals', value),
          icon: Icons.highlight,
        ),
        const SizedBox(height: 12),
        _buildDropdownField(
          label: 'Engine Sound',
          items: ['Good', 'Not Good'],
          value: viewModel.dropdownSelections['Engine Sound'],
          onChanged: (value) =>
              viewModel.updateDropdownSelection('Engine Sound', value),
          icon: Icons.engineering,
        ),
        const SizedBox(height: 12),
        _buildDropdownField(
          label: 'Brakes',
          items: ['Good', 'Not Good'],
          value: viewModel.dropdownSelections['Brakes'],
          onChanged: (value) =>
              viewModel.updateDropdownSelection('Brakes', value),
          icon: Icons.warning,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    required Function(String?) onSaved,
    IconData? icon,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: mainYellow.withOpacity(0.3)),
      ),
      child: TextFormField(
        initialValue: initialValue,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: textGrey),
          prefixIcon: icon != null
              ? Icon(icon, color: mainYellow.withOpacity(0.7))
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        style: const TextStyle(color: mainWhite),
        validator: (value) =>
            value?.isEmpty == true ? 'This field is required' : null,
        onSaved: onSaved,
      ),
    );
  }

  Widget _buildDropdownField({
  required String label,
  required List<String> items,
  required String? value,
  required Function(String?) onChanged,
  IconData? icon,
}) {
  return Container(
    decoration: BoxDecoration(
      color: cardBackground,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: mainYellow.withOpacity(0.3)),
    ),
    child: DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: textGrey),
        prefixIcon: icon != null
            ? Icon(icon, color: mainYellow.withOpacity(0.7))
            : null,
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      dropdownColor: cardBackground,
      style: const TextStyle(color: mainWhite),
      value: value, // This can now be null
      hint: Text('Select ${label.toLowerCase()}',
          style: const TextStyle(color: textGrey)),
      items: items
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item),
              ))
          .toList(),
      onChanged: onChanged,
      validator: (value) =>
          value == null ? 'Please select ${label.toLowerCase()}' : null,
    ),
  );
}

  Widget _buildSubmitButton(
      BuildContext context, PreInspectionFormViewModel viewModel) {
    return ElevatedButton(
      onPressed: viewModel.busy
          ? null
          : () {
              if (viewModel.formKey.currentState?.validate() ?? false) {
                viewModel.formKey.currentState?.save();
                viewModel.submitPreInspectionForm(
                  bookingId,
                  bookingDetails,
                );
              }
            },
      style: ElevatedButton.styleFrom(
        backgroundColor: mainYellow,
        foregroundColor: mainBlack,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (viewModel.busy)
            const Padding(
              padding: EdgeInsets.only(right: 10),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(mainBlack),
                ),
              ),
            ),
          Text(
            viewModel.busy ? 'Submitting...' : 'Submit Inspection',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _onWillPop(
      BuildContext context, PreInspectionFormViewModel viewModel) async {
    if (viewModel.formKey.currentState?.validate() ?? false) {
      final shouldPop = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: cardBackground,
          title: const Text('Discard Changes?',
              style: TextStyle(color: mainYellow)),
          content: const Text(
            'You have unsaved changes. Are you sure you want to go back?',
            style: TextStyle(color: mainWhite),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('No', style: TextStyle(color: textGrey)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Yes', style: TextStyle(color: mainYellow)),
            ),
          ],
        ),
      );
      return shouldPop ?? false;
    }
    return true;
  }
}
