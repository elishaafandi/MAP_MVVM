import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CallPage {
  static Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $launchUri';
    }
  }
}

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
  static const primaryYellow = Color(0xFFFFD700);
  static const backgroundBlack = Color(0xFF121212);
  static const cardBlack = Color(0xFF1E1E1E);
  static const textGrey = Color(0xFFB3B3B3);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: backgroundBlack,
        appBar: AppBar(
          backgroundColor: Colors.yellow.shade700,
          title: Text('Messages', style: TextStyle(color: Colors.black87)),
          bottom: TabBar(
            labelColor: Colors.black87,
            unselectedLabelColor: Colors.black54,
            tabs: [
              Tab(text: 'Notifications'),
              Tab(text: 'Chats'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildNotificationsTab(),
            ChatsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('bookings')
          .where('renteeId', isEqualTo: currentUserId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error loading notifications'));
        }

        if (!snapshot.hasData) {
          return Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(primaryYellow)));
        }

        final notifications = _processBookingNotifications(snapshot.data!.docs);

        if (notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications_none, size: 48, color: Colors.grey),
                SizedBox(height: 16),
                Text('No notifications', style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return _buildNotificationCard(notification);
          },
        );
      },
    );
  }

  // Inside _NotificationsPageState class, update the _processBookingNotifications method

  List<Map<String, dynamic>> _processBookingNotifications(
      List<QueryDocumentSnapshot> bookings) {
    final notifications = <Map<String, dynamic>>[];
    final now = DateTime.now();

    for (var booking in bookings) {
      final data = booking.data() as Map<String, dynamic>;

      // Skip completed bookings
      if (data['status'] == 'Completed') continue;

      // Check pickup time
      if (data['pickupDate'] != null && data['pickupTime'] != null) {
        try {
          final pickupDate =
              DateTime.parse('${data['pickupDate']} ${data['pickupTime']}');
          final hoursUntilPickup = pickupDate.difference(now).inHours;

          if (hoursUntilPickup > 0 && hoursUntilPickup <= 24) {
            notifications.add({
              'type': 'pickup',
              'title': 'Upcoming Vehicle Pickup',
              'message':
                  'Vehicle pickup in ${hoursUntilPickup} hours at ${data['location']}',
              'icon': Icons.access_time,
              'color': primaryYellow,
              'time': pickupDate,
              'priority': 1,
            });
          }
        } catch (e) {
          print('Error processing pickup date: $e');
        }
      }

      // Check return time
      if (data['returnDate'] != null && data['returnTime'] != null) {
        try {
          final returnDate =
              DateTime.parse('${data['returnDate']} ${data['returnTime']}');
          final hoursUntilReturn = returnDate.difference(now).inHours;

          if (hoursUntilReturn > 0 && hoursUntilReturn <= 24) {
            notifications.add({
              'type': 'return',
              'title': 'Vehicle Return Reminder',
              'message': 'Vehicle return in ${hoursUntilReturn} hours',
              'icon': Icons.event_available,
              'color': Colors.orange,
              'time': returnDate,
              'priority': 2,
            });
          }
        } catch (e) {
          print('Error processing return date: $e');
        }
      }

      // Status-based notifications based on renteeStatus
      final statusNotifications = {
        'approved': {
          'title': 'Booking Approved',
          'message':
              'Your booking has been approved. Please proceed with deposit payment.',
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
          'message':
              'Your deposit has been confirmed. Waiting for vehicle delivery.',
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
          'message':
              'Complete the pre-inspection form before using the vehicle.',
          'icon': Icons.assignment,
          'color': primaryYellow,
          'priority': 0,
        },
        'pre_inspection_confirmed': {
          'title': 'Action Required: Start Usage',
          'message':
              'Pre-inspection completed. You can now start using the vehicle.',
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

      if (statusNotifications.containsKey(data['renteeStatus'])) {
        final statusNotification = {
          ...statusNotifications[data['renteeStatus']]!
        };
        statusNotification['time'] = data['lastUpdated'];
        notifications.add(statusNotification);
      }
    }

    // Sort notifications by priority and time
    notifications.sort((a, b) {
      if (a['priority'] != b['priority']) {
        return a['priority'].compareTo(b['priority']);
      }
      return b['time'].compareTo(a['time']);
    });

    return notifications;
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: cardBlack,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: notification['color'],
          width: 2,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: notification['color'].withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            notification['icon'],
            color: notification['color'],
            size: 24,
          ),
        ),
        title: Text(
          notification['title'],
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              notification['message'],
              style: TextStyle(
                color: textGrey,
                fontSize: 14,
              ),
            ),
            if (notification['time'] != null) ...[
              SizedBox(height: 4),
              Text(
                _formatTimestamp(notification['time']),
                style: TextStyle(
                  color: textGrey,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return '';

    DateTime dateTime;
    if (timestamp is Timestamp) {
      dateTime = timestamp.toDate();
    } else if (timestamp is DateTime) {
      dateTime = timestamp;
    } else {
      return '';
    }

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}

class ChatsList extends StatelessWidget {
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
  static const primaryYellow = Color(0xFFFFD700);
  static const backgroundBlack = Color(0xFF121212);
  static const cardBlack = Color(0xFF1E1E1E);
  static const textGrey = Color(0xFFB3B3B3);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundBlack,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .orderBy('last_message_time', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text('Error loading chats',
                    style: TextStyle(color: Colors.white)));
          }

          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(primaryYellow)));
          }

          final chats = snapshot.data!.docs.where((doc) {
            final chatId = doc.id;
            final userIds = chatId.split('_');
            return userIds.contains(currentUserId);
          }).toList();

          chats.sort((a, b) {
            final aTime = (a.data()
                as Map<String, dynamic>)['last_message_time'] as Timestamp?;
            final bTime = (b.data()
                as Map<String, dynamic>)['last_message_time'] as Timestamp?;
            if (aTime == null || bTime == null) return 0;
            return bTime.compareTo(aTime);
          });

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chatDoc = chats[index];
              final chatId = chatDoc.id;
              final userIds = chatId.split('_');
              final renterId =
                  userIds[0] == currentUserId ? userIds[1] : userIds[0];

              return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(renterId)
                    .snapshots(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        color: cardBlack,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text('Loading...',
                            style: TextStyle(color: Colors.white)),
                      ),
                    );
                  }

                  final userData =
                      userSnapshot.data!.data() as Map<String, dynamic>;
                  final renterName = userData['username'] ?? 'Unknown User';
                  final contact = userData['contact'] ?? '';

                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: cardBlack,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: primaryYellow,
                        child: Text(
                          renterName[0],
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      title: Text(
                        renterName,
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('chats')
                                .doc(chatId)
                                .collection('messages')
                                .orderBy('timestamp', descending: true)
                                .limit(1)
                                .snapshots(),
                            builder: (context, msgSnapshot) {
                              String lastMessage = 'Start a conversation';
                              if (msgSnapshot.hasData &&
                                  msgSnapshot.data!.docs.isNotEmpty) {
                                final lastMsg = msgSnapshot.data!.docs.first
                                    .data() as Map<String, dynamic>;
                                lastMessage = lastMsg['text'] ?? 'No message';
                              }
                              return Text(
                                lastMessage,
                                style: TextStyle(color: textGrey),
                              );
                            },
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Course: ${userData['course'] ?? 'N/A'} • Matric: ${userData['matricNo'] ?? 'N/A'}',
                            style: TextStyle(color: textGrey, fontSize: 12),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.call, color: primaryYellow),
                            onPressed: () async {
                              if (contact.isNotEmpty) {
                                try {
                                  await CallPage.makePhoneCall(contact);
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('Could not make phone call'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Phone number not available'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatRoom(
                              chatId: chatId,
                              otherUserId: renterId,
                              otherUserName: renterName,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class ChatRoom extends StatefulWidget {
  final String chatId;
  final String otherUserId;
  final String otherUserName;

  ChatRoom({
    required this.chatId,
    required this.otherUserId,
    required this.otherUserName,
  });

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _messageController = TextEditingController();
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
  String? contact; // Add this line to store phone number
  static const primaryYellow = Color(0xFFFFD700);
  static const backgroundBlack = Color(0xFF121212);
  static const cardBlack = Color(0xFF1E1E1E);
  static const textGrey = Color(0xFFB3B3B3);

  @override
  void initState() {
    super.initState();
    _fetchPhoneNumber();
  }

  // Add this method to fetch phone number
  Future<void> _fetchPhoneNumber() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.otherUserId)
          .get();

      if (userDoc.exists) {
        setState(() {
          contact = userDoc.data()?['contact'];
        });
      }
    } catch (e) {
      print('Error fetching phone number: $e');
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    try {
      final messageText = _messageController.text.trim();
      final timestamp = FieldValue.serverTimestamp();

      await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .collection('messages')
          .add({
        'text': messageText,
        'senderId': currentUserId,
        'timestamp': timestamp,
      });

      await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .update({
        'last_message': messageText,
        'last_message_time': timestamp,
      });

      _messageController.clear();
    } catch (e) {
      print('Error sending message: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message')),
      );
    }
  }

  Future<void> _makeCall() async {
    if (contact != null && contact!.isNotEmpty) {
      try {
        await CallPage.makePhoneCall(contact!);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Could not make phone call'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Phone number not available'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundBlack,
      appBar: AppBar(
        backgroundColor: cardBlack,
        title: Text(
          widget.otherUserName,
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.call, color: primaryYellow),
            onPressed: _makeCall,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: backgroundBlack,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chats')
                    .doc(widget.chatId)
                    .collection('messages')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error loading messages',
                          style: TextStyle(color: Colors.white)),
                    );
                  }

                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(primaryYellow)),
                    );
                  }

                  final messages = snapshot.data!.docs;

                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message =
                          messages[index].data() as Map<String, dynamic>;
                      final isMyMessage = message['senderId'] == currentUserId;

                      return Align(
                        alignment: isMyMessage
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          padding: EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: isMyMessage ? primaryYellow : cardBlack,
                            borderRadius: BorderRadius.circular(8.0),
                            border: !isMyMessage
                                ? Border.all(color: textGrey.withOpacity(0.3))
                                : null,
                          ),
                          child: Text(
                            message['text'] ?? '',
                            style: TextStyle(
                              color: isMyMessage ? Colors.black : Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Container(
            color: cardBlack,
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: TextStyle(color: textGrey),
                      filled: true,
                      fillColor: backgroundBlack,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                  color: primaryYellow,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
