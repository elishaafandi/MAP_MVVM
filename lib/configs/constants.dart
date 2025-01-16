import 'package:flutter/material.dart';

class Constants {
  static const String appTitle = 'MoveEase';
  static const Color primaryYellow = Color(0xFFFFD700);
  static const Color backgroundBlack = Color(0xFF121212);
  static const Color cardGrey = Color(0xFF1E1E1E);
  static const Color textGrey = Color(0xFFB3B3B3);
}

class AppTheme {
  static const Color primaryYellow = Color(0xFFFFD700);
  static const Color backgroundBlack = Color(0xFF1E1E1E);
  static const Color cardBlack = Color(0xFF2A2A2A);
  static const Color textGrey = Color(0xFF8E8E8E);
  static const Color successGreen = Color.fromARGB(255, 6, 136, 12);
  static const Color mainWhite = Color.fromARGB(255, 255, 255, 255);
  static const Color errorRed = Color.fromARGB(255, 201, 23, 23);
}

enum ViewState {
  idle,
  busy,
  error,
}