import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:wetravel/firebase_options.dart';
import 'package:wetravel/presentation/pages/guide_package/filtered_guide_package_page.dart';
import 'package:wetravel/presentation/pages/login/login_page.dart';
import 'package:wetravel/presentation/pages/new_trip/scrap_package_page.dart';
import 'package:wetravel/presentation/pages/on_boarding/on_boarding_page.dart';
import 'package:wetravel/presentation/pages/stack/stack_page.dart';
import 'package:wetravel/presentation/pages/survey/city_selection_page.dart';
import 'package:wetravel/presentation/pages/survey/survey_page.dart';
import 'package:wetravel/presentation/pages/recommendation/ai_recommendation_page.dart';
import 'package:wetravel/presentation/pages/schedule/ai_schedule_page.dart';
import 'package:wetravel/presentation/pages/new_trip/new_trip_page.dart';
import 'package:wetravel/presentation/pages/plan_selection/plan_selection_page.dart';
import 'package:wetravel/presentation/pages/my_page/mypage.dart';
import 'package:wetravel/presentation/pages/saved_plans/saved_plans_page.dart';
import 'package:wetravel/theme.dart';
import 'package:flutter/cupertino.dart';

final analyticsProvider = Provider<FirebaseAnalytics>((ref) {
  return FirebaseAnalytics.instance;
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(
      widgetsBinding: WidgetsFlutterBinding.ensureInitialized()); // 스플래시 유지

  await Firebase.initializeApp(); // firebase 초기화
  final initialRoute =
      FirebaseAuth.instance.currentUser == null ? '/login' : '/';
  await dotenv.load(fileName: "assets/.env"); // .env 파일 로드
  FlutterNativeSplash.remove(); // 스플래시 제거

  // 앱 실행 시 상태 표시줄 글씨 색을 검은색으로 설정
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // sentry 활성화
  if (kReleaseMode) {
    final String? sentryDns = dotenv.env['SENTRY_DNS_KEY'];

    await SentryFlutter.init(
      (options) {
        options.dsn = sentryDns;
        options.attachStacktrace = true;
      },
      appRunner: () => runApp(
        ProviderScope(
          child: SentryWidget(
            child: MyApp(initialRoute: initialRoute),
          ),
        ),
      ),
    );
  } else {
    runApp(
      ProviderScope(
        child: MyApp(initialRoute: initialRoute),
      ),
    );
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key, required this.initialRoute});
  final String initialRoute;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.watch(analyticsProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      theme: AppTheme.themeData,
      initialRoute: initialRoute,
      routes: {
        '/': (context) {
          final int initialIndex =
              ModalRoute.of(context)?.settings.arguments as int? ?? 0;
          return StackPage(initialIndex: initialIndex);
        },
        '/login': (context) => const LoginPage(),
        '/city-selection': (context) => const CitySelectionPage(),
        '/survey': (context) => const SurveyPage(),
        '/new-trip': (context) => const NewTripPage(),
        '/plan-selection': (context) => const PlanSelectionPage(),
        '/ai-recommendation': (context) => const AIRecommendationPage(),
        '/ai-schedule': (context) => const AISchedulePage(),
        '/manual-planning': (context) => const FilteredGuidePackagePage(),
        '/mypage': (context) => MyPage(),
        '/saved-plans': (context) => SavedPlansPage(),
        '/saved-guide-plans': (context) => ScrapPackagesPage(),
        '/on-boarding': (context) => OnBoardingPage(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const StackPage(),
        );
      },
    );
  }
}
