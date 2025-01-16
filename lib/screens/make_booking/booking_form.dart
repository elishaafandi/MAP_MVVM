import 'package:flutter/material.dart';
import 'package:movease/screens/make_booking/make_booking_viewmodel.dart';
import 'package:movease/screens/submit_booking/submit_booking_view.dart';
import '../../configs/constants.dart';
//import '../submit_booking.dart';

class BookingForm extends StatefulWidget {
  final MakeBookingViewModel viewModel;
  final String vehicleId;

  const BookingForm({
    Key? key,
    required this.viewModel,
    required this.vehicleId,
  }) : super(key: key);

  @override
  _BookingFormState createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _pickupDateController = TextEditingController();
  final TextEditingController _pickupTimeController = TextEditingController();
  final TextEditingController _returnDateController = TextEditingController();
  final TextEditingController _returnTimeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Operating hours
  final TimeOfDay _openingTime = TimeOfDay(hour: 8, minute: 0); // 8 AM
  final TimeOfDay _closingTime = TimeOfDay(hour: 22, minute: 0); // 10 PM

  @override
  void dispose() {
    _locationController.dispose();
    _pickupDateController.dispose();
    _pickupTimeController.dispose();
    _returnDateController.dispose();
    _returnTimeController.dispose();
    super.dispose();
  }

  void _showLocationSuggestions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.backgroundBlack,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Select Location',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Divider(color: AppTheme.textGrey),
              Expanded(
                child: ListView(
                  children: ['KTDI', 'KTHO', 'KDSE']
                      .map((location) => ListTile(
                            title: Text(
                              location,
                              style: TextStyle(color: Colors.white),
                            ),
                            tileColor: AppTheme.cardBlack,
                            hoverColor: AppTheme.primaryYellow.withOpacity(0.1),
                            onTap: () {
                              setState(() {
                                _locationController.text = location;
                              });
                              Navigator.pop(context);
                            },
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectDate(TextEditingController controller) async {
    DateTime now = DateTime.now();
    DateTime minDate = now.add(Duration(days: 2));

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: minDate,
      firstDate: minDate,
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppTheme.primaryYellow,
              onPrimary: Colors.black,
              surface: AppTheme.cardBlack,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: AppTheme.backgroundBlack,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primaryYellow,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        controller.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  double _timeToDouble(TimeOfDay time) => time.hour + time.minute / 60.0;

  TimeOfDay _getValidInitialTime() {
    final now = TimeOfDay.now();
    if (_timeToDouble(now) < _timeToDouble(_openingTime)) {
      return _openingTime;
    }
    if (_timeToDouble(now) > _timeToDouble(_closingTime)) {
      return _openingTime;
    }
    return TimeOfDay(hour: now.hour + 1, minute: 0);
  }

  TimeOfDay _parseTimeString(String timeStr) {
    final parts = timeStr.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  Future<void> _selectTime(TextEditingController controller) async {
    final TimeOfDay initialTime = _getValidInitialTime();

    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: AppTheme.backgroundBlack,
              hourMinuteTextColor: Colors.white,
              dialBackgroundColor: AppTheme.cardBlack,
              dialHandColor: AppTheme.primaryYellow,
              dialTextColor: Colors.white,
              entryModeIconColor: AppTheme.primaryYellow,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primaryYellow,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      picked = TimeOfDay(hour: picked.hour, minute: 0);

      if (_timeToDouble(picked) < _timeToDouble(_openingTime) ||
          _timeToDouble(picked) > _timeToDouble(_closingTime)) {
        _showErrorSnackBar('Please select a time between 8 AM and 10 PM');
        return;
      }

      if (controller == _returnTimeController &&
          _pickupTimeController.text.isNotEmpty) {
        TimeOfDay pickupTime = _parseTimeString(_pickupTimeController.text);
        if (_timeToDouble(picked) <= _timeToDouble(pickupTime)) {
          _showErrorSnackBar(
              'Return time must be at least 1 hour after pickup time');
          return;
        }
      }

      setState(() {
        String hour = picked!.hour.toString().padLeft(2, '0');
        controller.text = '$hour:00';
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() &&
        widget.viewModel.validateBookingDates(
            _pickupDateController.text, _returnDateController.text) &&
        widget.viewModel.validateBookingTimes(
            _pickupTimeController.text, _returnTimeController.text)) {
      Map<String, String> bookingDetails = {
        'location': _locationController.text,
        'pickupDate': _pickupDateController.text,
        'pickupTime': _pickupTimeController.text,
        'returnDate': _returnDateController.text,
        'returnTime': _returnTimeController.text,
      };

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SubmitBookingView(
            vehicleId: widget.vehicleId,
            bookingDetails: bookingDetails,
          ),
        ),
      );
    }
  }

  Widget _buildStyledFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Function() onIconPressed,
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppTheme.textGrey),
        suffixIcon: IconButton(
          icon: Icon(icon, color: AppTheme.primaryYellow),
          onPressed: onIconPressed,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppTheme.textGrey),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppTheme.primaryYellow),
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: AppTheme.cardBlack,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.backgroundBlack,
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, MediaQuery.of(context).padding.bottom),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Booking Details',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 24),
                    _buildStyledFormField(
                      controller: _locationController,
                      label: 'Pickup Location',
                      icon: Icons.location_on,
                      onIconPressed: _showLocationSuggestions,
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStyledFormField(
                            controller: _pickupDateController,
                            label: 'Pickup Date',
                            icon: Icons.calendar_today,
                            onIconPressed: () =>
                                _selectDate(_pickupDateController),
                            readOnly: true,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _buildStyledFormField(
                            controller: _pickupTimeController,
                            label: 'Pickup Time',
                            icon: Icons.access_time,
                            onIconPressed: () =>
                                _selectTime(_pickupTimeController),
                            readOnly: true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStyledFormField(
                            controller: _returnDateController,
                            label: 'Return Date',
                            icon: Icons.calendar_today,
                            onIconPressed: () =>
                                _selectDate(_returnDateController),
                            readOnly: true,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _buildStyledFormField(
                            controller: _returnTimeController,
                            label: 'Return Time',
                            icon: Icons.access_time,
                            onIconPressed: () =>
                                _selectTime(_returnTimeController),
                            readOnly: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryYellow,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'SUBMIT BOOKING',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
