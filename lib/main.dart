import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/presentation/pages/survey/city_selection_page.dart';
import 'package:wetravel/presentation/pages/recommendation/ai_recommendation_page.dart';
import 'package:wetravel/presentation/pages/plan_selection/plan_selection_page.dart';
import 'package:wetravel/presentation/pages/survey/survey_page.dart';
import 'package:wetravel/theme.dart';
import 'package:wetravel/presentation/pages/schedule/ai_schedule_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(); // firebase 초기화
  await dotenv.load(fileName: "assets/.env"); // .env 파일 로드

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      initialRoute: '/',
      routes: {
        '/': (context) => const CitySelectionPage(),
        '/survey': (context) => const SurveyPage(),
        '/plan-selection': (context) => const PlanSelectionPage(),
        '/ai-recommendation': (context) => const AIRecommendationPage(),
        '/ai-schedule': (context) => const AISchedulePage(),
      },
    );
  }
}
