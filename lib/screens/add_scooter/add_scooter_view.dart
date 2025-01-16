import 'package:flutter/material.dart';
import 'package:map_mvvm/view/view.dart';
import 'add_scooter_viewmodel.dart';

class AddScooterView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  static const _yellowColor = Color.fromARGB(255, 255, 204, 20);

  @override
  Widget build(BuildContext context) {
    return ViewWrapper<AddScooterViewModel>(
      builder: (context, viewModel) => Scaffold(
        appBar: AppBar(
          title: Text('Add Scooter'),
          backgroundColor: const Color.fromARGB(255, 2, 77, 69),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Vehicle Name
                  TextFormField(
                    decoration: _inputDecoration('Vehicle Name'),
                    onSaved: (value) => viewModel.vehicleName = value ?? '',
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Please enter vehicle name'
                        : null,
                  ),
                  SizedBox(height: 16),

                  // Price Slider
                  Text(
                      'Price per Hour (RM ${viewModel.pricePerHour.toStringAsFixed(2)})',
                      style: TextStyle(fontSize: 16)),
                  Slider(
                    value: viewModel.pricePerHour,
                    min: 0.5,
                    max: 5.0,
                    divisions: 9,
                    label: 'RM ${viewModel.pricePerHour.toStringAsFixed(2)}',
                    onChanged: (value) => viewModel.updatePrice(value),
                    activeColor: _yellowColor,
                    inactiveColor: const Color.fromARGB(255, 170, 237, 232)
                        .withOpacity(0.4),
                  ),
                  SizedBox(height: 16),

                  // Scooter Type
                  Text('Scooter Type', style: TextStyle(fontSize: 16)),
                  Wrap(
                    spacing: 10.0,
                    children: ['Manual', 'Electric'].map((type) {
                      return ChoiceChip(
                        label: Text(type),
                        selected: viewModel.scooterType == type,
                        onSelected: (selected) {
                          if (selected) viewModel.scooterType = type;
                        },
                        selectedColor: _yellowColor,
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16),

                  // Availability
                  Row(
                    children: [
                      Text('Available Now', style: TextStyle(fontSize: 16)),
                      Switch(
                        value: viewModel.availability,
                        onChanged: (value) => viewModel.availability = value,
                        activeColor: _yellowColor,
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  // Save Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          viewModel.saveScooter().then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Scooter saved successfully!')),
                            );
                            Navigator.pop(context);
                          }).catchError((error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('Error saving scooter: $error')),
                            );
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 10, 108, 77),
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      ),
                      child:
                          Text('Save Scooter', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: const Color.fromARGB(255, 169, 228, 200)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: const Color.fromARGB(255, 169, 228, 200)),
      ),
    );
  }
}
