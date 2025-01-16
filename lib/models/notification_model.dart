// lib/models/notification_model.dart

import 'package:flutter/material.dart';

class NotificationModel {
  final String id;
  final String type;
  final String title;
  final String message;
  final IconData icon;
  final Color color;
  final DateTime timestamp;
  final int priority;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.icon,
    required this.color,
    required this.timestamp,
    required this.priority,
    required this.isRead,
  });

  NotificationModel copyWith({
    String? id,
    String? type,
    String? title,
    String? message,
    IconData? icon,
    Color? color,
    DateTime? timestamp,
    int? priority,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      timestamp: timestamp ?? this.timestamp,
      priority: priority ?? this.priority,
      isRead: isRead ?? this.isRead,
    );
  }
}