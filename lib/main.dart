// lib/main.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'configs/constants.dart';
import 'configs/routes.dart';
import 'configs/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize service locator
  initializeServiceLocator();
  FirebaseFirestore.instance.settings = Settings(
    persistenceEnabled: false,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.appTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.yellow.shade700,
          brightness: Brightness.light,
        ),
      ),
      onGenerateRoute: Routes.createRoute,
      initialRoute: Routes.login,
    );
  }
}
