import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:map_mvvm/view/viewmodel.dart';
import 'package:movease/models/user_model.dart';
import '../../services/user/user_service.dart';
import '../../models/role_card_data.dart';
import '../../configs/service_locator.dart';
import 'package:movease/models/user_role.dart';

class RoleSelectionViewModel extends Viewmodel {
  final UserService _userService = locator<UserService>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String username = 'Loading...';
  StreamSubscription<User?>? _authSubscription;

  final roleCards = [
    RoleCardData(
      image: 'assets/images/renter.png',
      title: 'Renter',
      subtitle: 'Get your car rented to earn extra income.',
      role: UserRole.renter,
    ),
    RoleCardData(
      image: 'assets/images/rentee.png',
      title: 'Rentee',
      subtitle: 'Rent a vehicle for your next trip or task.',
      role: UserRole.rentee,
    ),
  ];

  RoleSelectionViewModel() {
    // Initialize auth state listener
    _authSubscription = _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        fetchUsername();
      } else {
        username = 'No user logged in';
        update();
      }
    });

    // Initial fetch
    fetchUsername();
  }

  Future<void> fetchUsername() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        // Use the stream to get real-time updates
        await for (final UserModel? userModel
            in _userService.getUserStream(currentUser.email!)) {
          if (userModel != null) {
            username = userModel.username;
            update();
            break; // Break after first update if you don't need continuous updates
          }
        }
      } else {
        username = 'No user logged in';
        update();
      }
    } catch (e) {
      username = 'Error fetching username';
      print('Error fetching username: $e');
      update();
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
