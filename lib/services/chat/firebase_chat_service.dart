import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/chat_message_model.dart';
import '../../models/chat_user_model.dart';
import 'chat_service.dart';

class FirebaseChatService implements ChatService {
  final FirebaseFirestore _firestore;

  FirebaseChatService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<ChatMessageModel>> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessageModel.fromMap(
                doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  @override
  Future<void> sendMessage(String chatId, String senderId, String text) async {
    await _firestore.collection('chats').doc(chatId).collection('messages').add({
      'senderId': senderId,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await _firestore.collection('chats').doc(chatId).update({
      'last_message': text,
      'last_message_time': FieldValue.serverTimestamp(),
    });
  }

   @override
  Future<String?> getUserContact(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    return doc.data()?['contact'] as String?;
  }

  @override
  Stream<List<QueryDocumentSnapshot>> getChats(String userId) {
    return _firestore
        .collection('chats')
        .orderBy('last_message_time', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .where((doc) => doc.id.split('_').contains(userId))
            .toList());
  }

  @override
  Future<ChatUserModel> getUserDetails(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    return ChatUserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }
}
