import 'package:flutter/material.dart';
import 'package:map_mvvm/view/view.dart';
import 'renter_viewmodel.dart';
import 'vehicle_list.dart';
import 'constants.dart';

class RenterBody extends StatelessWidget {
  const RenterBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewWrapper<RenterViewModel>(
      builder: (_, viewmodel) {
        final List<Widget> pages = [
          VehicleList(
            vehicles: viewmodel.vehicles,
            isLoading: viewmodel.busy,
            onAddVehicle: () => viewmodel.navigateToAddVehicle(context),
            onDeleteVehicle: (id) => viewmodel.deleteVehicle(id),
            onToggleAvailability: (String id, bool value) =>
                viewmodel.toggleVehicleAvailability(id, value),
          ),
          const Center(
              child: Text('Booking Status',
                  style: TextStyle(fontSize: 20, color: Colors.white))),
          const Center(
              child: Text('Rental Status',
                  style: TextStyle(fontSize: 20, color: Colors.white))),
          const Center(
              child: Text('Feedback',
                  style: TextStyle(fontSize: 20, color: Colors.white))),
          const Center(
              child: Text('Notifications',
                  style: TextStyle(fontSize: 20, color: Colors.white))),
          const Center(
              child: Text('Profile',
                  style: TextStyle(fontSize: 20, color: Colors.white))),
        ];

        return Container(
          color: backgroundBlack,
          child: pages[viewmodel.selectedIndex],
        );
      },
    );
  }
}
