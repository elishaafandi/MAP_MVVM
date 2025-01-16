import 'package:flutter/material.dart';
import 'package:map_mvvm/view/view.dart';
import 'package:movease/models/notification_model.dart';
import 'package:movease/screens/chat_list_rentee/chat_list_rentee_view.dart';
import 'package:movease/screens/notification_rentee/notification_card.dart';
import 'package:movease/screens/notification_rentee/notification_rentee_viewmodel.dart';

class NotificationsPage extends StatelessWidget {
  static const backgroundBlack = Color(0xFF121212);
  static const primaryYellow = Color(0xFFFFD700);

  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewWrapper<NotificationViewModel>(
      builder: (context, viewModel) => DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: backgroundBlack,
          appBar: AppBar(
            backgroundColor: Colors.yellow.shade700,
            title:
                const Text('Messages', style: TextStyle(color: Colors.black87)),
            bottom: const TabBar(
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
              _buildNotificationsTab(viewModel),
              ChatsListRenteeView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationsTab(NotificationViewModel viewModel) {
    return StreamBuilder<List<NotificationModel>>(
      stream: viewModel.notificationsStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading notifications'));
        }

        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryYellow),
            ),
          );
        }

        final notifications = snapshot.data!;

        if (notifications.isEmpty) {
          return const Center(
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
          itemBuilder: (context, index) =>
              NotificationCard(notification: notifications[index]),
        );
      },
    );
  }
}
