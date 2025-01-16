// External packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:map_mvvm/app/service_locator.dart';
import 'package:movease/models/booking_with_details.dart';
import 'package:movease/screens/add_bicycle/add_bicycle_viewmodel.dart';
import 'package:movease/screens/add_car/add_car_viewmodel.dart';
import 'package:movease/screens/add_motorcycle/add_motorcycle_viewmodel.dart';
import 'package:movease/screens/add_scooter/add_scooter_viewmodel.dart';
import 'package:movease/screens/add_vehicle/add_vehicle_viewmodel.dart';
import 'package:movease/screens/booking_list/booking_list_viewmodel.dart';
import 'package:movease/screens/booking_request/booking_request_viewmodel.dart';
import 'package:movease/screens/booking_status_rentee/booking_status_rentee_viewmodel.dart';
import 'package:movease/screens/booking_status_renter/booking_status_renter_viewm';
import 'package:movease/screens/chat_list_rentee/chat_list_rentee_viewmodel.dart';
import 'package:movease/screens/chat_room_rentee/chat_room_rentee_viewmodel.dart';
import 'package:movease/screens/edit_vehicle/edit_vehicle_viewmodel.dart';

import 'package:movease/screens/make_booking/make_booking_viewmodel.dart';
import 'package:movease/screens/notification_rentee/notification_rentee_viewmodel.dart';
import 'package:movease/screens/pay_deposit/pay_deposit_viewmodel.dart';
import 'package:movease/screens/pre_inspection/pre_inspection_form_viewmodel.dart';
import 'package:movease/screens/rentee/rentee_viewmodel.dart';
import 'package:movease/screens/rentee_status/rentee_status_viewmodel.dart';
import 'package:movease/screens/renter_status/renter_status_viewmodel.dart';
import 'package:movease/screens/submit_booking/submit_booking_viewmodel.dart';

// Services
import 'package:movease/services/auth/auth_service.dart';
import 'package:movease/services/auth/firebase_auth_service.dart';
import 'package:movease/services/booking/booking_service.dart';
import 'package:movease/services/booking/firebase_booking_service.dart';
import 'package:movease/services/chat/chat_service.dart';
import 'package:movease/services/chat/firebase_chat_service.dart';
import 'package:movease/services/deposit/deposit_service.dart';
import 'package:movease/services/deposit/firebase_deposit_service.dart';
import 'package:movease/services/notification/firebase_notification_service.dart';
import 'package:movease/services/notification/notification_service.dart';

import 'package:movease/services/user/user_service.dart';
import 'package:movease/services/user/firebase_user_service.dart';

// ViewModels
import 'package:movease/screens/login/login_viewmodel.dart';
import 'package:movease/screens/registration/registration_viewmodel.dart';
import 'package:movease/screens/role_selection/role_selection_viewmodel.dart';
import 'package:movease/screens/reset_password/reset_password_viewmodel.dart';
import 'package:movease/screens/renter/renter_viewmodel.dart';
import 'package:movease/services/vehicle/firebase_vehicle_service.dart';
import 'package:movease/services/vehicle/vehicle_service.dart';

final locator = ServiceLocator.locator;
void initializeServiceLocator() {
  // Register Services
  locator.registerLazySingleton<AuthService>(
    () => FirebaseAuthService(),
  );

  locator.registerLazySingleton<UserService>(
    () => FirebaseUserService(),
  );

  locator.registerLazySingleton<BookingService>(
    () => FirebaseBookingService(),
  );

  // Register ViewModels
  locator.registerLazySingleton<LoginViewModel>(
    // Change this from registerFactory
    () => LoginViewModel(),
  );

  locator.registerLazySingleton<RegistrationViewModel>(
    () => RegistrationViewModel(),
  );

  locator.registerLazySingleton<RoleSelectionViewModel>(
    () => RoleSelectionViewModel(),
  );

  locator.registerLazySingleton<ResetPasswordViewmodel>(
    () => ResetPasswordViewmodel(),
  );

  locator.registerLazySingleton<VehicleService>(
    () => FirebaseVehicleService(),
  );

  locator.registerLazySingleton<NotificationService>(
    () => FirebaseNotificationService(
      firestore: FirebaseFirestore.instance,
    ),
  );

  locator.registerLazySingleton<ChatService>(
    () => FirebaseChatService(),
  );

  locator.registerLazySingleton<RenterViewModel>(
    () => RenterViewModel(
      vehicleService: locator<VehicleService>(),
      authService: locator<AuthService>(),
    ),
  );

  locator.registerLazySingleton<AddVehicleViewModel>(
    () => AddVehicleViewModel(
      vehicleService: locator<VehicleService>(),
      authService: locator<AuthService>(),
    ),
  );

  locator.registerLazySingleton<AddCarViewModel>(
    () => AddCarViewModel(
      vehicleService: locator<VehicleService>(),
      authService: locator<AuthService>(),
    ),
  );

  locator.registerLazySingleton<AddScooterViewModel>(
    () => AddScooterViewModel(
      vehicleService: locator<VehicleService>(),
      authService: locator<AuthService>(),
    ),
  );

  locator.registerLazySingleton<AddBicycleViewModel>(
    () => AddBicycleViewModel(
      vehicleService: locator<VehicleService>(),
      authService: locator<AuthService>(),
    ),
  );

  locator.registerLazySingleton<AddMotorcycleViewModel>(
    () => AddMotorcycleViewModel(
      vehicleService: locator<VehicleService>(),
      authService: locator<AuthService>(),
    ),
  );

  locator.registerLazySingleton<RenteeViewModel>(
    () => RenteeViewModel(
      vehicleService: locator<VehicleService>(),
      authService: locator<AuthService>(),
    ),
  );

  locator.registerFactory<MakeBookingViewModel>(
    () => MakeBookingViewModel(
      vehicleService: locator<VehicleService>(),
      bookingService: locator<BookingService>(),
    ),
  );

  locator.registerFactory<SubmitBookingViewModel>(
    () => SubmitBookingViewModel(
      vehicleService: locator<VehicleService>(),
      bookingService: locator<BookingService>(),
    ),
  );

  locator.registerFactory(() => BookingRequestViewModel(
        bookingService: locator<BookingService>(),
      ));

  locator.registerFactory(() => BookingListViewModel(
        bookingService: locator<BookingService>(),
      ));

  // Register BookingStatusViewModel
  locator.registerFactory(() => BookingStatusRenteeViewModel());

  locator.registerFactory(() => BookingStatusRenterViewModel());

  locator.registerFactory(() => RenteeStatusViewModel(
        bookingService: locator<BookingService>(),
        vehicleService: locator<VehicleService>(),
      ));

  locator.registerFactory(() => RenterStatusViewModel(
        bookingService: locator<BookingService>(),
        vehicleService: locator<VehicleService>(),
      ));

  locator
      .registerFactoryParam<EditVehicleViewModel, Map<String, dynamic>, void>(
    (vehicleData, _) => EditVehicleViewModel(
      vehicleService: locator<VehicleService>(),
      vehicleId: vehicleData['id'] as String,
      initialData: vehicleData,
      vehicleType: vehicleData['type'] as String,
    ),
  );

  locator.registerLazySingleton<PreInspectionFormViewModel>(
      () => PreInspectionFormViewModel(
            locator<VehicleService>(),
          ));

  locator.registerLazySingleton<DepositService>(
    () => FirebaseDepositService(),
  );

  locator.registerFactoryParam<PayDepositViewModel, BookingWithDetails, void>(
    (booking, _) => PayDepositViewModel(
      depositService: locator<DepositService>(),
      booking: booking,
    ),
  );

  locator.registerFactory(() => NotificationViewModel(
        notificationService: locator<NotificationService>(),
        currentUserId: FirebaseAuth.instance.currentUser?.uid ?? '',
      ));

  locator.registerFactory(() => ChatsListRenteeViewModel(
        chatService: locator<ChatService>(),
        currentUserId: FirebaseAuth.instance.currentUser?.uid ?? '',
      ));

    locator.registerFactoryParam<ChatRoomViewModel, Map<String, String>, void>(
    (params, _) => ChatRoomViewModel(
      chatService: locator<ChatService>(),
      chatId: params['chatId']!,
      currentUserId: params['currentUserId']!,
      otherUserId: params['otherUserId']!,
    ),
  );
}
