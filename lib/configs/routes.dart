import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movease/chats_rentee.dart';
import 'package:movease/configs/service_locator.dart';
import 'package:movease/models/booking_with_details.dart';
import 'package:movease/screens/add_bicycle/add_bicycle_view.dart';
import 'package:movease/screens/add_car/add_car_view.dart';
import 'package:movease/screens/add_scooter/add_scooter_view.dart';
import 'package:movease/screens/add_vehicle/add_vehicle_view.dart';
import 'package:movease/screens/add_motorcycle/add_motorcycle_view.dart';
import 'package:movease/screens/booking_request/booking_request_view.dart';
import 'package:movease/screens/booking_status_rentee/booking_status_rentee_view.dart';
import 'package:movease/screens/booking_status_renter/booking_status_renter_viewmodel.dart';
import 'package:movease/screens/chat_room_rentee/chat_room_rentee_view.dart';
import 'package:movease/screens/edit_vehicle/edit_vehicle_view.dart';
import 'package:movease/screens/edit_vehicle/edit_vehicle_viewmodel.dart';
import 'package:movease/screens/make_booking/make_booking_view.dart';
import 'package:movease/screens/pay_deposit/pay_deposit_view.dart';
import 'package:movease/screens/registration/registration_view.dart';
import 'package:movease/screens/rentee_feedback/rentee_feedback_view.dart';
import 'package:movease/screens/rentee_status/rentee_status_view.dart';
import 'package:movease/screens/rentee_status/rentee_status_viewmodel.dart';
import 'package:movease/screens/renter_feedback/renter_feedback_view.dart';
import 'package:movease/screens/renter_status/renter_status_view.dart';
import 'package:movease/screens/renter_status/renter_status_viewmodel.dart';
import 'package:movease/screens/reset_password/reset_password_view.dart';
import '../screens/login/login_view.dart';
import '../screens/role_selection/role_selection_view.dart';
import '../screens/renter/renter.dart';
import '../screens/rentee/rentee_view.dart';

class Routes {
  static const String login = '/login';
  static const String registration = '/registration';
  static const String roleSelection = '/role-selection';
  static const String resetPassword = '/resetPassword';
  static const String renter = '/renter';
  static const String addVehicle = '/add-vehicle';
  static const String vehicleForm = '/vehicle-form';
  static const String addCar = '/add-car';
  static const String addScooter = '/add-scooter';
  static const String addBicycle = '/add-bicycle';
  static const String addMotorcyle = '/add-motorcycle';
  static const String rentee = '/rentee';
  static const String booking = '/booking';
  static const String makeBooking = '/make-booking';
  static const String bookingRequest = '/booking-request';
  static const bookingStatus = '/booking-status';
  static const bookingStatusRenter = '/booking-status-renter';
  static const renteeStatus = '/rentee-status';
  static const renterStatus = '/renter-status';
  static const String editVehicle = '/edit-vehicle';
  static const String payDeposit = '/pay-deposit';
  static const String chatRentee = '/chat-rentee';
  static const String notifications = '/notifications';
  static const String chatRoom = '/chat-room';
  static const String renteeFeedback = '/rentee-feedback';
  static const String renterFeedback = '/renter-feedback';

  static Route<dynamic>? createRoute(settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case registration:
        return MaterialPageRoute(builder: (_) => RegistrationScreen());
      case roleSelection:
        return MaterialPageRoute(builder: (_) => const RoleSelectionPage());
      case resetPassword:
        return MaterialPageRoute(builder: (_) => const ResetPasswordScreen());

      case renter:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => RenterPage(username: args['username'] as String));
      case addVehicle:
        return MaterialPageRoute(builder: (_) => AddVehiclePage());

      case '/add-car':
        return MaterialPageRoute(builder: (_) => AddCarView());

      case '/add-scooter':
        return MaterialPageRoute(builder: (_) => AddScooterView());

      case '/add-bicycle':
        return MaterialPageRoute(builder: (_) => AddBicycleView());

      case '/add-motorcycle':
        return MaterialPageRoute(builder: (_) => AddMotorcycleView());

      case rentee:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => RenteePage(username: args['username'] as String),
        );

      case makeBooking:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) =>
              MakeBookingView(vehicleId: args['vehicleId'] as String),
        );

      case bookingRequest:
        return MaterialPageRoute(
          builder: (_) => BookingRequestView(),
        );

      case bookingStatus:
        return MaterialPageRoute(
          builder: (_) => BookingStatusRenteeView(),
        );
      case bookingStatusRenter:
        return MaterialPageRoute(
          builder: (_) => BookingStatusRenterView(),
        );

      case renteeStatus:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => RenteeStatusView(
            bookingDetails: args,
            viewModel: locator<RenteeStatusViewModel>(),
          ),
        );
      case renterStatus:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => RenterStatusView(
            bookingDetails: args,
            viewModel: locator<RenterStatusViewModel>(),
          ),
        );
      case editVehicle:
        final args = settings.arguments;
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (_) => EditVehicleView(
              vehicle: args,
              viewModel: locator.get<EditVehicleViewModel>(param1: args),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Invalid vehicle data'),
            ),
          ),
        );

      case payDeposit:
        final args = settings.arguments as Map<String, dynamic>;
        final booking =
            BookingWithDetails.fromMap(args, args['bookingId'] ?? '');
        return MaterialPageRoute(
          builder: (_) => PayDepositView(booking: booking),
        );

      case notifications:
        return MaterialPageRoute(
          builder: (context) => NotificationsPage(),
        );

      // In Routes.dart, update the chatRoom case:

      // In Routes.dart:

      // In Routes.dart:

      case chatRoom:
        if (settings.arguments == null) {
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              backgroundColor: Color(0xFF121212),
              body: Center(
                child: Text('Missing chat data',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          );
        }

        try {
          final Map<String, dynamic> args =
              Map<String, dynamic>.from(settings.arguments as Map);

          final String? chatId = args['chatId']?.toString();
          final String? otherUserId = args['otherUserId']?.toString();
          final String? otherUserName = args['otherUserName']?.toString();

          if (chatId == null || otherUserId == null || otherUserName == null) {
            return MaterialPageRoute(
              builder: (_) => Scaffold(
                backgroundColor: Color(0xFF121212),
                body: Center(
                  child: Text('Invalid chat data',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            );
          }

          return MaterialPageRoute(
            builder: (_) => ChatRoomView(
              chatId: chatId,
              otherUserId: otherUserId,
              otherUserName: otherUserName,
            ),
          );
        } catch (e) {
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              backgroundColor: Color(0xFF121212),
              body: Center(
                child: Text('Error loading chat',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          );
        }

      case renteeFeedback:
        return MaterialPageRoute(
          builder: (_) => RenteeFeedbackView(),
        );

      case renterFeedback:
        return MaterialPageRoute(
          builder: (_) => RenterFeedbackView(),
        );
    }
    return null;
  }
}
