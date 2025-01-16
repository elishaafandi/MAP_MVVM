import 'package:flutter/material.dart';
import 'package:map_mvvm/view/viewmodel.dart';
import '../../services/chat/chat_service.dart';
import '../../models/chat_data_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatsListRenteeViewModel extends Viewmodel {
  final ChatService _chatService;
  final String currentUserId;
  List<ChatDataModel> chats = [];

  ChatsListRenteeViewModel({
    required ChatService chatService,
    required this.currentUserId,
  }) : _chatService = chatService;

  Stream<List<ChatDataModel>> get chatsStream =>
      _chatService.getChats(currentUserId).asyncMap(_processChats);

  Future<List<ChatDataModel>> _processChats(var chatDocs) async {
    chats = [];
    for (var doc in chatDocs) {
      final chatId = doc.id;
      final userIds = chatId.split('_');
      final otherUserId = userIds[0] == currentUserId ? userIds[1] : userIds[0];

      final userData = await _chatService.getUserDetails(otherUserId);
      final lastMessage = await _getLastMessage(chatId);

      chats.add(ChatDataModel(
        chatId: chatId,
        userId: otherUserId,
        username: userData.username,
        contact: userData.contact,
        course: userData.course,
        matricNo: userData.matricNo,
        lastMessage: lastMessage,
      ));
    }
    notifyListeners();
    return chats;
  }

  Future<String> _getLastMessage(String chatId) async {
    final messages = await _chatService.getMessages(chatId).first;
    return messages.isNotEmpty ? messages.first.text : 'Start a conversation';
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void navigateToChatRoom(BuildContext context, String chatId,
      String otherUserId, String otherUserName) {
    Navigator.pushNamed(
      context,
      '/chat-room',
      arguments: {
        'chatId': chatId,
        'otherUserId': otherUserId,
        'otherUserName': otherUserName,
      },
    );
  }
}
