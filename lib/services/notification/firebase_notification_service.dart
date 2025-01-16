import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movease/models/notification_model.dart';
import 'package:movease/services/notification/notification_service.dart';

class FirebaseNotificationService implements NotificationService {
  final FirebaseFirestore _firestore;
  static const primaryYellow = Color(0xFFFFD700);

  FirebaseNotificationService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<NotificationModel>> getNotifications(String userId) {
    return _firestore
        .collection('bookings')
        .where('renteeId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => _processNotifications(snapshot.docs));
  }

  List<NotificationModel> _processNotifications(
      List<QueryDocumentSnapshot> bookings) {
    final notifications = <NotificationModel>[];
    final now = DateTime.now();

    for (var booking in bookings) {
      final data = booking.data() as Map<String, dynamic>;
      if (data['status'] == 'Completed') continue;

      _processPickupNotification(data, now, notifications);
      _processReturnNotification(data, now, notifications);
      _processStatusNotification(data, notifications);
    }

    notifications.sort((a, b) {
      if (a.priority != b.priority) {
        return a.priority.compareTo(b.priority);
      }
      return b.timestamp.compareTo(a.timestamp);
    });

    return notifications;
  }

  void _processPickupNotification(Map<String, dynamic> data, DateTime now,
      List<NotificationModel> notifications) {
    if (data['pickupDate'] != null && data['pickupTime'] != null) {
      try {
        final pickupDate =
            DateTime.parse('${data['pickupDate']} ${data['pickupTime']}');
        final hoursUntilPickup = pickupDate.difference(now).inHours;

        if (hoursUntilPickup > 0 && hoursUntilPickup <= 24) {
          notifications.add(NotificationModel(
            id: '${data['id']}_pickup',
            type: 'pickup',
            title: 'Upcoming Vehicle Pickup',
            message:
                'Vehicle pickup in ${hoursUntilPickup} hours at ${data['location']}',
            icon: Icons.access_time,
            color: primaryYellow,
            timestamp: pickupDate,
            priority: 1,
            isRead: false,
          ));
        }
      } catch (e) {
        print('Error processing pickup date: $e');
      }
    }
  }

  void _processReturnNotification(Map<String, dynamic> data, DateTime now,
      List<NotificationModel> notifications) {
    if (data['returnDate'] != null && data['returnTime'] != null) {
      try {
        final returnDate =
            DateTime.parse('${data['returnDate']} ${data['returnTime']}');
        final hoursUntilReturn = returnDate.difference(now).inHours;

        if (hoursUntilReturn > 0 && hoursUntilReturn <= 24) {
          notifications.add(NotificationModel(
            id: '${data['id']}_return',
            type: 'return',
            title: 'Vehicle Return Reminder',
            message: 'Vehicle return in ${hoursUntilReturn} hours',
            icon: Icons.event_available,
            color: Colors.orange,
            timestamp: returnDate,
            priority: 2,
            isRead: false,
          ));
        }
      } catch (e) {
        print('Error processing return date: $e');
      }
    }
  }

  void _processStatusNotification(
      Map<String, dynamic> data, List<NotificationModel> notifications) {
    final statusNotifications = _getStatusNotificationsMap();
    if (statusNotifications.containsKey(data['renteeStatus'])) {
      final statusNotification = statusNotifications[data['renteeStatus']]!;
      notifications.add(NotificationModel(
        id: '${data['id']}_${data['renteeStatus']}',
        type: data['renteeStatus'],
        title: statusNotification['title'],
        message: statusNotification['message'],
        icon: statusNotification['icon'],
        color: statusNotification['color'],
        timestamp: (data['lastUpdated'] as Timestamp).toDate(),
        priority: statusNotification['priority'],
        isRead: false,
      ));
    }
  }

  Map<String, Map<String, dynamic>> _getStatusNotificationsMap() {
    return {
      'approved': {
        'title': 'Booking Approved',
        'message': 'Your booking has been approved. Please proceed with deposit payment.',
        'icon': Icons.check_circle,
        'color': Colors.green,
        'priority': 0,
      },
      'booking_confirmed': {
        'title': 'Action Required: Deposit Payment',
        'message': 'Complete deposit payment to proceed with your booking.',
        'icon': Icons.payment,
        'color': Colors.red,
        'priority': 0,
      },
      'deposit_paid': {
        'title': 'Deposit Payment Confirmed',
        'message': 'Your deposit has been confirmed. Waiting for vehicle delivery.',
        'icon': Icons.paid,
        'color': Colors.green,
        'priority': 0,
      },
      'vehicle_delivery': {
        'title': 'Action Required: Confirm Delivery',
        'message': 'Confirm that you have received the vehicle.',
        'icon': Icons.local_shipping,
        'color': primaryYellow,
        'priority': 0,
      },
      'vehicle_delivery_confirmed': {
        'title': 'Action Required: Pre-inspection',
        'message': 'Complete the pre-inspection form before using the vehicle.',
        'icon': Icons.assignment,
        'color': primaryYellow,
        'priority': 0,
      },
      'pre_inspection_confirmed': {
        'title': 'Action Required: Start Usage',
        'message': 'Pre-inspection completed. You can now start using the vehicle.',
        'icon': Icons.drive_eta,
        'color': primaryYellow,
        'priority': 0,
      },
      'use_vehicle_confirmed': {
        'title': 'Vehicle In Use',
        'message': 'Vehicle usage period has started.',
        'icon': Icons.car_rental,
        'color': Colors.green,
        'priority': 0,
      },
      'return_vehicle': {
        'title': 'Return Process Started',
        'message': 'Vehicle return process has been initiated.',
        'icon': Icons.assignment_return,
        'color': Colors.orange,
        'priority': 0,
      },
      'post_inspection_completed': {
        'title': 'Action Required: Post-inspection',
        'message': 'Review and confirm post-inspection details.',
        'icon': Icons.fact_check,
        'color': primaryYellow,
        'priority': 0,
      },
      'post_inspection_confirmed': {
        'title': 'Action Required: Final Payment',
        'message': 'Complete the final payment.',
        'icon': Icons.payment,
        'color': Colors.red,
        'priority': 0,
      },
      'final_payment_completed': {
        'title': 'Rental Complete',
        'message': 'Final payment received. Please rate your experience.',
        'icon': Icons.star_border,
        'color': Colors.green,
        'priority': 0,
      },
      'renter_rated': {
        'title': 'Booking Completed',
        'message': 'Thank you for using our service!',
        'icon': Icons.check_circle_outline,
        'color': Colors.green,
        'priority': 0,
      },
    };
  }
}