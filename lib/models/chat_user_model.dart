class ChatUserModel {
  final String id;
  final String username;
  final String contact;
  final String course;
  final String matricNo;

  ChatUserModel({
    required this.id,
    required this.username,
    required this.contact,
    required this.course,
    required this.matricNo,
  });

  factory ChatUserModel.fromMap(Map<String, dynamic> map, String id) {
    return ChatUserModel(
      id: id,
      username: map['username'] ?? 'Unknown User',
      contact: map['contact'] ?? '',
      course: map['course'] ?? 'N/A',
      matricNo: map['matricNo'] ?? 'N/A',
    );
  }
}
