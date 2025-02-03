import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/presentation/pages/login/login_page.dart';
import 'package:wetravel/presentation/pages/stack/stack_page.dart';
import 'package:wetravel/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(
      widgetsBinding: WidgetsFlutterBinding.ensureInitialized()); // 스플래시 유지

  await Firebase.initializeApp(); // firebase 초기화
  await dotenv.load(fileName: "assets/.env"); // .env 파일 로드

  FlutterNativeSplash.remove(); // 스플래시 제거
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          User? user = snapshot.data;
          if (snapshot.hasData) {
            print(user);
            return StackPage();
          } else {
            print(user);
            return LoginPage();
          }
        },
      ),
    );
  }
}
