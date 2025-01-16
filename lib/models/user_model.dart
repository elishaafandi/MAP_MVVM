import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String username;
  final String email;
  String? password;
  final String matricNo;
  final String course;
  final String address;
  final DateTime createdAt;

  UserModel({
    required this.username,
    required this.email,
    this.password,
    required this.matricNo,
    required this.course,
    required this.address,
    required this.createdAt,
  });

  Map<String, dynamic> toJSON() {
    return {
      'username': username,
      'email': email,
      //'password': password,
      'matricNo': matricNo,
      'course': course,
      'address': address,
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
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      matricNo: json['matricNo'] ?? '',
      course: json['course'] ?? '',
      address: json['address'] ?? '',
      createdAt: parseDate(json['createdAt']),
    );
  }

  Map<String, dynamic> toMap() => toJSON();
  factory UserModel.fromMap(Map<String, dynamic> map) =>
      UserModel.fromJSON(map);
}
