import 'package:flutter/material.dart';
import 'package:map_mvvm/view/view.dart';
import 'add_car_viewmodel.dart';

class AddCarView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  static const _yellowColor = Color.fromARGB(255, 255, 204, 20);

  @override
  Widget build(BuildContext context) {
    return ViewWrapper<AddCarViewModel>(
      builder: (context, viewModel) => Scaffold(
        appBar: AppBar(
          title: Text('Add Car'),
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
                    max: 30.0,
                    divisions: 25,
                    label: 'RM ${viewModel.pricePerHour.toStringAsFixed(2)}',
                    onChanged: (value) => viewModel.updatePrice(value),
                    activeColor: _yellowColor,
                    inactiveColor: const Color.fromARGB(255, 170, 237, 232)
                        .withOpacity(0.4),
                  ),
                  SizedBox(height: 16),

                  // Transmission Type
                  Text('Transmission Type', style: TextStyle(fontSize: 16)),
                  Wrap(
                    spacing: 10.0,
                    children: ['Manual', 'Automatic'].map((type) {
                      return ChoiceChip(
                        label: Text(type),
                        selected: viewModel.transmissionType == type,
                        onSelected: (selected) {
                          if (selected) viewModel.transmissionType = type;
                        },
                        selectedColor: _yellowColor,
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16),

                  // Fuel Type
                  Text('Fuel Type', style: TextStyle(fontSize: 16)),
                  Wrap(
                    spacing: 10.0,
                    children: ['Petrol', 'Electric'].map((type) {
                      return ChoiceChip(
                        label: Text(type),
                        selected: viewModel.fuelType == type,
                        onSelected: (selected) {
                          if (selected) viewModel.fuelType = type;
                        },
                        selectedColor: _yellowColor,
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16),

                  // Seater Type
                  Text('Seater Type', style: TextStyle(fontSize: 16)),
                  Wrap(
                    spacing: 10.0,
                    children: ['4 Seater', '6 Seater', '8 Seater'].map((type) {
                      return ChoiceChip(
                        label: Text(type),
                        selected: viewModel.seaterType == type,
                        onSelected: (selected) {
                          if (selected) viewModel.seaterType = type;
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
                          viewModel.saveCar().then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Car saved successfully!')),
                            );
                            Navigator.pop(context);
                          }).catchError((error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Error saving car: $error')),
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
                      child: Text('Save Car', style: TextStyle(fontSize: 16)),
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
