import 'package:flutter/material.dart';
import '../../models/vehicle.dart';

class VehicleGrid extends StatelessWidget {
  final List<Vehicle> vehicles;
  final bool isLoading;

  const VehicleGrid({
    Key? key,
    required this.vehicles,
    required this.isLoading,
  }) : super(key: key);

  String _getVehicleImage(String name) {
    try {
      // Replace spaces with hyphens and convert to lowercase
      String sanitizedName = name.toLowerCase().trim().replaceAll(' ', '-');
      // Remove any special characters
      sanitizedName = sanitizedName.replaceAll(RegExp(r'[^a-z0-9-]'), '');
      return 'assets/images/$sanitizedName.png';
    } catch (e) {
      return 'assets/images/default_vehicle.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: Colors.yellow[700],
        ),
      );
    }

    return vehicles.isEmpty
        ? Center(
            child: Text(
              'No vehicles available.',
              style: TextStyle(color: Colors.grey[400]),
            ),
          )
        : GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: vehicles.length,
            itemBuilder: (context, index) {
              final vehicle = vehicles[index];
              return _buildVehicleCard(context, vehicle);
            },
          );
  }

  Widget _buildVehicleCard(BuildContext context, Vehicle vehicle) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 24, 24, 24),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[900]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 18, 18, 18),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Image.asset(
                      _getVehicleImage(vehicle.name),
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Row(
                      children: [
                        Icon(Icons.star, color: Colors.yellow[700], size: 16),
                        SizedBox(width: 4),
                        Text(
                          '4.5',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vehicle.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "\RM ${vehicle.price}/hour",
                  style: TextStyle(
                    color: Colors.yellow[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/make-booking',
                        arguments: {'vehicleId': vehicle.id},
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow[700],
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      "Book Now",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
