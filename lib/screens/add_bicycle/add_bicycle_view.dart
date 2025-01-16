import 'package:flutter/material.dart';
import 'package:map_mvvm/view/view.dart';
import 'add_bicycle_viewmodel.dart';

class AddBicycleView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  static const _yellowColor = Color.fromARGB(255, 255, 204, 20);

  @override
  Widget build(BuildContext context) {
    return ViewWrapper<AddBicycleViewModel>(
      builder: (context, viewModel) => Scaffold(
        appBar: AppBar(
          title: Text('Add Bicycle'),
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
                    decoration: _inputDecoration('Bicycle Name'),
                    onSaved: (value) => viewModel.vehicleName = value ?? '',
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Please enter bicycle name'
                        : null,
                  ),
                  SizedBox(height: 16),

                  // Price Slider
                  Text(
                      'Price per Hour (RM ${viewModel.pricePerHour.toStringAsFixed(2)})',
                      style: TextStyle(fontSize: 16)),
                  Slider(
                    value: viewModel.pricePerHour,
                    min: 3.0,
                    max: 10.0,
                    divisions: 9,
                    label: 'RM ${viewModel.pricePerHour.toStringAsFixed(2)}',
                    onChanged: (value) => viewModel.updatePrice(value),
                    activeColor: _yellowColor,
                    inactiveColor: const Color.fromARGB(255, 170, 237, 232)
                        .withOpacity(0.4),
                  ),
                  SizedBox(height: 16),

                  // Scooter Type
                  Text('Bicycle Type', style: TextStyle(fontSize: 16)),
                  Wrap(
                    spacing: 10.0,
                    children: ['Mountain', 'Road', 'Hybrid'].map((type) {
                      return ChoiceChip(
                        label: Text(type),
                        selected: viewModel.bicycleType == type,
                        onSelected: (selected) {
                          if (selected) viewModel.bicycleType = type;
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
                          viewModel.saveBicycle().then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Bicycle saved successfully!')),
                            );
                            Navigator.pop(context);
                          }).catchError((error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('Error saving bicycle: $error')),
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
                          Text('Save Bicycle', style: TextStyle(fontSize: 16)),
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
