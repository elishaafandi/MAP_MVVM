import 'package:flutter/material.dart';
import 'package:movease/configs/routes.dart';
import 'package:movease/models/vehicle.dart';
import 'constants.dart';

class VehicleList extends StatelessWidget {
  final List vehicles;
  final bool isLoading;
  final VoidCallback onAddVehicle;
  final Function(String) onDeleteVehicle;
  final Function(String, bool) onToggleAvailability;

  const VehicleList({
    Key? key,
    required this.vehicles,
    required this.isLoading,
    required this.onAddVehicle,
    required this.onDeleteVehicle,
    required this.onToggleAvailability,
  }) : super(key: key);

  String _getVehicleImagePath(String vehicleName) {
    // Keep 'x70' as is, only lowercase the 'Proton' part
    String processedName = vehicleName;
    try {
      // Replace spaces with hyphens and convert to lowercase
      String processedName =
          vehicleName.toLowerCase().trim().replaceAll(' ', '-');
      // Remove any special characters
      processedName = processedName.replaceAll(RegExp(r'[^a-z0-9-]'), '');
      return 'assets/images/$processedName.png';
    } catch (e) {
      return 'assets/images/default_vehicle.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(primaryYellow),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryYellow,
              foregroundColor: backgroundBlack,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
              elevation: 5,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.add, size: 24),
                SizedBox(width: 8),
                Text(
                  'Add Vehicle',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            onPressed: onAddVehicle,
          ),
        ),
        Expanded(
          child: vehicles.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.directions_car,
                        size: 80,
                        color: primaryYellow.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No vehicles found',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: vehicles.length,
                  itemBuilder: (context, index) {
                    final vehicle = vehicles[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: cardGrey,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                            child: Image.asset(
                              _getVehicleImagePath(vehicle.name),
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 200,
                                  color: Colors.grey[900],
                                  child: Icon(
                                    Icons.directions_car,
                                    size: 80,
                                    color: primaryYellow.withOpacity(0.5),
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      vehicle.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '\$${vehicle.price}/hour',
                                      style: const TextStyle(
                                        color: primaryYellow,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Type: ${vehicle.type}',
                                  style: const TextStyle(
                                    color: textGrey,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Added Availability Toggle
                                    Row(
                                      children: [
                                        const Text(
                                          'Available',
                                          style: TextStyle(
                                            color: textGrey,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Switch(
                                          value: vehicle.availability,
                                          onChanged: (bool value) {
                                            onToggleAvailability(
                                                vehicle.id, value);
                                          },
                                          activeColor: primaryYellow,
                                          activeTrackColor:
                                              primaryYellow.withOpacity(0.5),
                                          inactiveThumbColor: Colors.grey,
                                          inactiveTrackColor:
                                              Colors.grey.withOpacity(0.5),
                                        ),
                                      ],
                                    ),
                                    // Action buttons
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit,
                                              color: Colors.white),
                                          onPressed: () {
                                            if (vehicle is Vehicle) {
                                              Map<String, dynamic> vehicleData =
                                                  {
                                                'id': vehicle.id,
                                                'type': vehicle.type,
                                                'vehicle_name': vehicle.name,
                                                'price_per_hour': vehicle.price,
                                                'user_id': vehicle.userId,
                                                'availability':
                                                    vehicle.availability,
                                              };

                                              Navigator.pushNamed(
                                                context,
                                                Routes.editVehicle,
                                                arguments: vehicleData,
                                              );
                                            }
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete,
                                              color: Colors.red[400]),
                                          onPressed: () =>
                                              onDeleteVehicle(vehicle.id),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
