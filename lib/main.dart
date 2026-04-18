import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app.dart';

void main() async {
  // Ensure Flutter bindings are initialized before calling async methods
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Core Services & Firebase
  await _initializeCoreServices();

  runApp(ArenaFlowApp());
}

Future<void> _initializeCoreServices() async {
  try {
    // Attempt Firebase init; catches if no options or API keys provided locally
    await Firebase.initializeApp();
    debugPrint("Firebase Initialized Successfully");
  } catch (e) {
    debugPrint("Firebase init graceful fallback (Mock Mode): $e");
  }

  // Mock delay to simulate fetching configuration
  await Future.delayed(const Duration(milliseconds: 500));
  debugPrint("Local DAOs Configured");
}
