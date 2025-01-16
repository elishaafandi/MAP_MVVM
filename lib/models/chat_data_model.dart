class ChatDataModel {
  final String chatId;
  final String userId;
  final String username;
  final String contact;
  final String course;
  final String matricNo;
  final String lastMessage;

  ChatDataModel({
    required this.chatId,
    required this.userId,
    required this.username,
    required this.contact,
    required this.course,
    required this.matricNo,
    required this.lastMessage,
  });

  factory ChatDataModel.fromMap(Map<String, dynamic> map) {
    return ChatDataModel(
      chatId: map['chatId'] ?? '',
      userId: map['userId'] ?? '',
      username: map['username'] ?? '',
      contact: map['contact'] ?? '',
      course: map['course'] ?? '',
      matricNo: map['matricNo'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
    );
  }
}
