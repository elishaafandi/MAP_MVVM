import 'package:flutter/material.dart';
import 'package:map_mvvm/view/view.dart';
import 'add_motorcycle_viewmodel.dart';

class AddMotorcycleView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  static const _yellowColor = Color.fromARGB(255, 255, 204, 20);

  @override
  Widget build(BuildContext context) {
    return ViewWrapper<AddMotorcycleViewModel>(
      builder: (context, viewModel) => Scaffold(
        appBar: AppBar(
          title: Text('Add Motorcycle'),
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
                  // Brand Dropdown
                  DropdownButtonFormField<String>(
                    decoration: _inputDecoration('Vehicle Brand'),
                    value: viewModel.vehicleBrand.isEmpty
                        ? null
                        : viewModel.vehicleBrand,
                    items: viewModel.vehicleBrands.keys.map((brand) {
                      return DropdownMenuItem(value: brand, child: Text(brand));
                    }).toList(),
                    onChanged: (value) => viewModel.updateBrand(value!),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Please select a brand' : null,
                  ),
                  SizedBox(height: 16),

                  // Model Dropdown
                  if (viewModel.vehicleBrand.isNotEmpty)
                    DropdownButtonFormField<String>(
                      decoration: _inputDecoration('Vehicle Model'),
                      value: viewModel.vehicleModel.isEmpty
                          ? null
                          : viewModel.vehicleModel,
                      items: viewModel.vehicleBrands[viewModel.vehicleBrand]!
                          .map((model) {
                        return DropdownMenuItem(
                            value: model, child: Text(model));
                      }).toList(),
                      onChanged: (value) => viewModel.updateModel(value!),
                      validator: (value) => value?.isEmpty ?? true
                          ? 'Please select a model'
                          : null,
                    ),
                  SizedBox(height: 16),

                  // Plate Number
                  TextFormField(
                    decoration: _inputDecoration('Plate Number'),
                    onSaved: (value) => viewModel.plateNo = value ?? '',
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Please enter plate number'
                        : null,
                  ),
                  SizedBox(height: 16),

                  // Price Slider
                  Text(
                      'Price per Hour (RM ${viewModel.pricePerHour.toStringAsFixed(2)})',
                      style: TextStyle(fontSize: 16)),
                  Slider(
                    value: viewModel.pricePerHour,
                    min: 5.0,
                    max: 15.0,
                    divisions: 25,
                    label: 'RM ${viewModel.pricePerHour.toStringAsFixed(2)}',
                    onChanged: (value) => viewModel.updatePrice(value),
                    activeColor: _yellowColor,
                    inactiveColor: const Color.fromARGB(255, 170, 237, 232)
                        .withOpacity(0.4),
                  ),
                  SizedBox(height: 16),

                  // Motorcycle Type
                  Text('Motorcycle Type', style: TextStyle(fontSize: 16)),
                  Wrap(
                    spacing: 10.0,
                    children: ['Standard', 'Cruiser', 'Sport', 'Adventure']
                        .map((type) {
                      return ChoiceChip(
                        label: Text(type),
                        selected: viewModel.motorcycleType == type,
                        onSelected: (selected) {
                          if (selected) viewModel.motorcycleType = type;
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
                          viewModel.saveMotorcycle().then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('Motorcycle saved successfully!')),
                            );
                            Navigator.pop(context);
                          }).catchError((error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('Error saving motorcycle: $error')),
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
                      child: Text('Save Motorcycle',
                          style: TextStyle(fontSize: 16)),
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
