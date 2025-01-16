import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/chat_message_model.dart';
import '../../models/chat_user_model.dart';

abstract class ChatService {
  Stream<List<ChatMessageModel>> getMessages(String chatId);
  Future<void> sendMessage(String chatId, String senderId, String text);
  Stream<List<QueryDocumentSnapshot>> getChats(String userId);
  Future<ChatUserModel> getUserDetails(String userId);
   Future<String?> getUserContact(String userId);
}
