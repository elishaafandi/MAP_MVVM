import 'package:flutter/material.dart';
import 'package:map_mvvm/view/view.dart';
import 'package:movease/models/chat_message_model.dart';
import 'package:movease/screens/chat_room_rentee/chat_room_rentee_viewmodel.dart';

class ChatRoomView extends StatelessWidget {
  final String chatId;
  final String otherUserId;
  final String otherUserName;

  static const primaryYellow = Color(0xFFFFD700);
  static const backgroundBlack = Color(0xFF121212);
  static const cardBlack = Color(0xFF1E1E1E);
  static const textGrey = Color(0xFFB3B3B3);

  const ChatRoomView({
    required this.chatId,
    required this.otherUserId,
    required this.otherUserName,
  });

  @override
  Widget build(BuildContext context) {
    return ViewWrapper<ChatRoomViewModel>(
      builder: (context, viewModel) => Scaffold(
        backgroundColor: backgroundBlack,
        appBar: AppBar(
          backgroundColor: cardBlack,
          title: Text(
            otherUserName,
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.call, color: primaryYellow),
              onPressed: viewModel.makePhoneCall,
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<ChatMessageModel>>(
                stream: viewModel.messagesStream,
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
                          valueColor: AlwaysStoppedAnimation<Color>(primaryYellow)),
                    );
                  }

                  final messages = snapshot.data!;
                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isMyMessage = message.senderId == viewModel.currentUserId;

                      return _buildMessageBubble(message, isMyMessage);
                    },
                  );
                },
              ),
            ),
            _buildMessageInput(viewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessageModel message, bool isMyMessage) {
    return Align(
      alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isMyMessage ? primaryYellow : cardBlack,
          borderRadius: BorderRadius.circular(8.0),
          border: !isMyMessage
              ? Border.all(color: textGrey.withOpacity(0.3))
              : null,
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: isMyMessage ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput(ChatRoomViewModel viewModel) {
    return Container(
      color: cardBlack,
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: viewModel.messageController,
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
            onPressed: viewModel.sendMessage,
            color: primaryYellow,
          ),
        ],
      ),
    );
  }
}
