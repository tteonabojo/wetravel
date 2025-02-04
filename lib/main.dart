import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/presentation/pages/auth_wrapper/auth_wrapper.dart';
import 'package:wetravel/presentation/pages/login/login_page.dart';
import 'package:wetravel/presentation/pages/stack/stack_page.dart';
import 'package:wetravel/presentation/pages/survey/city_selection_page.dart';
import 'package:wetravel/presentation/pages/survey/survey_page.dart';
import 'package:wetravel/presentation/pages/recommendation/ai_recommendation_page.dart';
import 'package:wetravel/presentation/pages/schedule/ai_schedule_page.dart';
import 'package:wetravel/presentation/pages/new_trip/new_trip_page.dart';
import 'package:wetravel/presentation/pages/plan_selection/plan_selection_page.dart';
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
      initialRoute: '/init',
      routes: {
        '/': (context) => const StackPage(),
        '/init': (context) => const AuthWrapper(),
        '/login': (context) => const LoginPage(),
        '/city-selection': (context) => const CitySelectionPage(),
        '/survey': (context) => const SurveyPage(),
        '/new-trip': (context) => const NewTripPage(),
        '/plan-selection': (_) =>
            const ProviderScope(child: PlanSelectionPage()),
        '/ai-recommendation': (context) => const AIRecommendationPage(),
        '/ai-schedule': (context) => const AISchedulePage(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const StackPage(),
        );
      },
    );
  }
}
