import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wetravel/firebase_options.dart';
import 'package:wetravel/presentation/pages/user_list/user_list_page.dart';

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
    return MaterialApp(
      home: UserListPage(),
    );
  }
}
