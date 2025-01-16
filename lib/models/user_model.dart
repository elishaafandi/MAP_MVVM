import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String username;
  final String email;
  String? password;
  final String matricNo;
  final String course;
  final String address;
  final String? profilePhoto;  // Added for profile photo
  final DateTime createdAt;
  final int userId;  // Added userId field

  UserModel({
    required this.username,
    required this.email,
    this.password,
    required this.matricNo,
    required this.course,
    required this.address,
    this.profilePhoto,  // Made optional
    required this.createdAt,
    required this.userId,
  });

  Map<String, dynamic> toJSON() {
    return {
      'userId': userId,
      'username': username,
      'email': email,
      'matricNo': matricNo,
      'course': course,
      'address': address,
      'profilePhoto': profilePhoto,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory UserModel.fromJSON(Map<String, dynamic> json) {
    DateTime parseDate(dynamic value) {
      if (value is Timestamp) {
        return value.toDate();
      } else if (value is String) {
        return DateTime.parse(value);
      } else if (value is DateTime) {
        return value;
      }
      return DateTime.now();
    }

    return UserModel(
      userId: json['userId'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      password: json['password'],
      matricNo: json['matricNo'] ?? '',
      course: json['course'] ?? '',
      address: json['address'] ?? '',
      profilePhoto: json['profilePhoto'],
      createdAt: parseDate(json['createdAt']),
    );
  }

  Map<String, dynamic> toMap() => toJSON();
  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel.fromJSON(map);
}