import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore용
import 'package:firebase_database/firebase_database.dart'; // Realtime Database용
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp();
  }
}

// Firestore 데이터베이스 사용 예시:
final FirebaseFirestore firestore = FirebaseFirestore.instance;

// Realtime Database 사용 예시:
final FirebaseDatabase database = FirebaseDatabase.instance;
