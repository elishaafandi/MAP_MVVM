import 'package:flutter/material.dart';
import 'package:map_mvvm/view/view.dart';
import 'package:movease/configs/routes.dart';
import 'package:movease/configs/service_locator.dart';
import 'package:movease/screens/chat_room_rentee/chat_room_rentee_view.dart';
import 'package:movease/screens/chat_room_rentee/chat_room_rentee_viewmodel.dart';
import 'package:movease/services/chat/chat_service.dart';
import '../../models/chat_data_model.dart';
import 'chat_list_rentee_viewmodel.dart';

class ChatsListRenteeView extends StatelessWidget {
  static const primaryYellow = Color(0xFFFFD700);
  static const backgroundBlack = Color(0xFF121212);
  static const cardBlack = Color(0xFF1E1E1E);
  static const textGrey = Color(0xFFB3B3B3);

  @override
  Widget build(BuildContext context) {
    return ViewWrapper<ChatsListRenteeViewModel>(
      builder: (context, viewModel) => Container(
        color: backgroundBlack,
        child: StreamBuilder<List<ChatDataModel>>(
          stream: viewModel.chatsStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                  child: Text('Error loading chats',
                      style: TextStyle(color: Colors.white)));
            }

            if (!snapshot.hasData) {
              return Center(
                  child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(primaryYellow)));
            }

            return ListView.builder(
              itemCount: viewModel.chats.length,
              itemBuilder: (context, index) {
                final chat = viewModel.chats[index];
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
                        chat.username[0],
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    title: Text(
                      chat.username,
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chat.lastMessage,
                          style: TextStyle(color: textGrey),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Course: ${chat.course} • Matric: ${chat.matricNo}',
                          style: TextStyle(color: textGrey, fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.call, color: primaryYellow),
                      onPressed: () => viewModel.makePhoneCall(chat.contact),
                    ),
                    // In ChatsListRenteeView:

                    // In ChatsListRenteeView, update the onTap handler:

                    // In ChatsListRenteeView, update the onTap handler:

                    // In ChatsListRenteeView, update the onTap handler:

                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ViewWrapper<ChatRoomViewModel>(
                            builder: (context, viewModel) => ChatRoomView(
                              chatId: chat.chatId,
                              otherUserId: chat.userId,
                              otherUserName: chat.username,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
