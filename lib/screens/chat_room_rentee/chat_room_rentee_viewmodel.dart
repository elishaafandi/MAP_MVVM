import 'package:flutter/material.dart';
import 'package:map_mvvm/view/viewmodel.dart';
import 'package:movease/models/chat_message_model.dart';
import '../../services/chat/chat_service.dart';

class ChatRoomViewModel extends Viewmodel {
  final ChatService _chatService;
  final String chatId;
  final String currentUserId;
  final TextEditingController messageController = TextEditingController();
  String? otherUserContact;

  ChatRoomViewModel({
    required ChatService chatService,
    required this.chatId,
    required this.currentUserId,
    required String otherUserId,
  }) : _chatService = chatService {
    _fetchUserContact(otherUserId);
  }

  Stream<List<ChatMessageModel>> get messagesStream =>
      _chatService.getMessages(chatId);

  Future<void> _fetchUserContact(String userId) async {
    otherUserContact = await _chatService.getUserContact(userId);
    notifyListeners();
  }

  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty) return;

    try {
      await _chatService.sendMessage(
        chatId,
        currentUserId,
        messageController.text.trim(),
      );
      messageController.clear();
    } catch (e) {
      debugPrint('Error sending message: $e');
    }
  }

  Future<void> makePhoneCall() async {
    if (otherUserContact == null || otherUserContact!.isEmpty) {
      throw Exception('Phone number not available');
    }
    // Implement phone call functionality
  }
}