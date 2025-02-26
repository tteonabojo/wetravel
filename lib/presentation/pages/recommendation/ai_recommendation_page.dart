import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/domain/entity/survey_response.dart';
import 'package:wetravel/presentation/provider/recommendation_provider.dart';
// kDebugMode를 사용하기 위한 import
import 'widgets/recommendation_app_bar.dart';
import 'mixins/ad_handling_mixin.dart';
import 'widgets/loading_view.dart';
import 'widgets/recommendation_list_view.dart';
import 'widgets/bottom_buttons.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// AI 추천 페이지
class AIRecommendationPage extends ConsumerStatefulWidget {
  const AIRecommendationPage({super.key});

  @override
  ConsumerState<AIRecommendationPage> createState() =>
      _AIRecommendationPageState();
}

class _AIRecommendationPageState extends ConsumerState<AIRecommendationPage>
    with AdHandlingMixin {
  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  void _loadInterstitialAd() {
    loadInterstitialAd(
      onAdLoaded: (ad) {
        _interstitialAd = ad;
        setState(() {
          _isAdLoaded = true;
        });
      },
      onAdFailedToLoad: (error) {
        // print 문 제거
      },
    );
  }

  void _showAdAndRefresh() {
    if (_isAdLoaded && _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _refreshRecommendations();
          _loadInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _refreshRecommendations();
          _loadInterstitialAd();
        },
      );
      _interstitialAd!.show();
      setState(() {
        _isAdLoaded = false;
      });
    } else {
      _refreshRecommendations();
    }
  }

  void _refreshRecommendations() {
    // 여행지 추천 다시 로드
    final surveyResponse =
        ModalRoute.of(context)!.settings.arguments as SurveyResponse;

    // 두 프로바이더 모두 리프레시
    ref.refresh(recommendationProvider(surveyResponse));
    ref.refresh(recommendationNotifierProvider);

    // 명시적으로 새 데이터 로드 요청
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(recommendationNotifierProvider.notifier)
          .loadRecommendations(surveyResponse);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRecommendations();
    });
  }

  void _loadRecommendations() {
    final survey = _getSurveyResponse();
    if (survey != null) {
      ref
          .read(recommendationNotifierProvider.notifier)
          .loadRecommendations(survey);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(recommendationNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const RecommendationAppBar(),
      body: state.isLoading
          ? const LoadingView()
          : RecommendationListView(
              destinations: state.destinations,
              reasons: state.reasons,
              selectedDestination: state.selectedDestination,
              onDestinationSelected: (destination) {
                ref
                    .read(recommendationNotifierProvider.notifier)
                    .selectDestination(destination);
              },
            ),
      bottomNavigationBar: state.isLoading
          ? null
          : BottomButtons(
              onRecommendationPressed: _showAdAndRefresh,
              selectedDestination: state.selectedDestination,
              surveyResponse: _getSurveyResponse()!,
              isAdLoading: isAdLoading,
            ),
    );
  }

  /// Survey Response 가져오기
  SurveyResponse? _getSurveyResponse() {
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args == null) {
      return SurveyResponse(
        travelPeriod: '2024',
        travelDuration: '3일',
        companions: [],
        travelStyles: [],
        accommodationTypes: [],
        considerations: [],
      );
    }

    if (args is SurveyResponse) {
      return args;
    }

    return SurveyResponse(
      travelPeriod: '2024',
      travelDuration: '3일',
      companions: [],
      travelStyles: [],
      accommodationTypes: [],
      considerations: [],
      selectedCity: args.toString(),
    );
  }
}
