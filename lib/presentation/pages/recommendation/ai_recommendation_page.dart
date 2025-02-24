import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_shadow.dart';
import 'package:wetravel/core/constants/app_spacing.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/domain/entity/survey_response.dart';
import 'package:wetravel/presentation/provider/recommendation_provider.dart';
import 'package:wetravel/presentation/widgets/buttons/standard_button.dart';
import 'package:lottie/lottie.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io' show Platform;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/foundation.dart'; // kDebugMode를 사용하기 위한 import

class AIRecommendationPage extends ConsumerStatefulWidget {
  const AIRecommendationPage({super.key});

  @override
  ConsumerState<AIRecommendationPage> createState() =>
      _AIRecommendationPageState();
}

class _AIRecommendationPageState extends ConsumerState<AIRecommendationPage> {
  // 상태 변수들
  String? selectedDestination;
  final Map<String, String> _imageCache = {};
  List<String> destinations = [];
  List<String> reasons = [];
  bool _isLoading = true;
  bool _isFirstLoad = true;
  RewardedAd? _rewardedAd;
  bool _isAdLoading = false;

  /// 광고 ID 설정 (릴리즈/디버그 모드 동일하게 실제 광고 ID 사용)
  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-5444380029598582/3444349489' // Android 실제 광고 ID
      : 'ca-app-pub-5444380029598582/6818185842'; // iOS 실제 광고 ID

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirstLoad) {
      _loadRecommendations();
      _isFirstLoad = false;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadRewardedAd();
  }

  @override
  void dispose() {
    _imageCache.clear();
    _rewardedAd?.dispose();
    super.dispose();
  }

  /// AI 추천 목록을 로드하는 함수
  Future<void> _loadRecommendations() async {
    if (!mounted) return;

    try {
      setState(() {
        _isLoading = true;
        destinations = [];
        reasons = [];
        selectedDestination = null;
      });

      final args =
          ModalRoute.of(context)?.settings.arguments as SurveyResponse?;
      if (args == null) {
        throw Exception('No survey response provided');
      }

      final recommendation =
          await ref.read(recommendationProvider(args).future);

      if (!mounted) return;

      setState(() {
        destinations = recommendation.destinations;
        reasons = recommendation.reasons;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        destinations = [];
        reasons = [];
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('추천을 가져오는데 실패했습니다: $e')),
      );
    }
  }

  /// 보상형 광고 로드 함수
  Future<void> _loadRewardedAd() async {
    if (_isAdLoading) return;

    setState(() {
      _isAdLoading = true;
    });

    try {
      await RewardedAd.load(
        adUnitId: _adUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: _handleAdLoaded,
          onAdFailedToLoad: _handleAdFailedToLoad,
        ),
      );
    } catch (e) {
      _handleAdError();
    }
  }

  /// 광고 로드 성공 핸들러
  void _handleAdLoaded(RewardedAd ad) {
    setState(() {
      _rewardedAd = ad;
      _isAdLoading = false;
    });

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        _loadRecommendations();
        _loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: _handleAdShowError,
      onAdShowedFullScreenContent: (ad) {},
    );
  }

  /// 광고 로드 실패 핸들러
  void _handleAdFailedToLoad(LoadAdError error) {
    setState(() {
      _isAdLoading = false;
    });

    // 에러 정보 로깅
    if (kDebugMode) {
      print('Ad failed to load with error:');
      print('Message: ${error.message}');
      print('Code: ${error.code}');
      print('Domain: ${error.domain}');
      print('Response info: ${error.responseInfo}');
    }

    _showErrorSnackBar('광고를 불러오는데 실패했습니다. 다시 시도해주세요.');
  }

  /// 광고 표시 실패 핸들러
  void _handleAdShowError(RewardedAd ad, AdError error) {
    ad.dispose();
    _rewardedAd = null;
    _isAdLoading = false;
    _showErrorSnackBar('광고 표시에 실패했습니다. 다시 시도해주세요.');
  }

  /// 광고 초기화 에러 핸들러
  void _handleAdError() {
    setState(() {
      _isAdLoading = false;
    });
    if (mounted) {
      _showErrorSnackBar('광고 서비스를 초기화하는데 실패했습니다.');
    }
  }

  /// 에러 메시지 표시 함수
  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  /// 보상형 광고 표시 함수
  Future<void> _showRewardedAd() async {
    final bool? shouldShowAd = await _showAdConfirmDialog();

    if (shouldShowAd != true) return;

    if (_isAdLoading) {
      _showErrorSnackBar('광고를 불러오는 중입니다. 잠시만 기다려주세요.');
      return;
    }

    if (_rewardedAd == null) {
      _showErrorSnackBar('광고를 불러오는데 실패했습니다. 다시 시도해주세요.');
      return;
    }

    try {
      await _rewardedAd!.show(onUserEarnedReward: (_, reward) {});
    } catch (e) {
      debugPrint('광고 표시 중 오류 발생: $e');
    }
  }

  /// 광고 시청 확인 다이얼로그
  Future<bool?> _showAdConfirmDialog() {
    return showCupertinoDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('알림'),
          content: const Text('광고 시청 후 다시 추천 받기가 가능합니다'),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(false),
              child:
                  Text('취소', style: TextStyle(color: AppColors.grayScale_450)),
            ),
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('확인', style: TextStyle(color: AppColors.primary_450)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading ? _buildLoadingView() : _buildMainContent(),
    );
  }

  /// 로딩 화면 위젯
  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/lottie/loading_animation.json',
            width: 200,
            height: 200,
          ),
          const SizedBox(height: 20),
          Text(
            'AI가 여행지를 추천하고 있어요',
            style: AppTypography.body1.copyWith(
              color: AppColors.grayScale_450,
            ),
          ),
        ],
      ),
    );
  }

  /// 메인 컨텐츠 위젯
  Widget _buildMainContent() {
    return SafeArea(
      child: Column(
        children: [
          _buildAppBar(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                Expanded(child: _buildDestinationList()),
                const SizedBox(height: 20),
                _buildBottomButtons(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 앱바 위젯
  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: Text(
        'AI 맞춤 여행지 추천',
        style: AppTypography.headline4.copyWith(
          color: AppColors.grayScale_950,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            '/',
            (route) => false,
          ),
        ),
      ],
    );
  }

  /// 헤더 위젯
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.grayScale_050,
          borderRadius: AppBorderRadius.small12,
        ),
        child: Text(
          '리스트를 확인하고 나에게 맞는 여행지를 선택해주세요',
          style: AppTypography.body2.copyWith(
            color: AppColors.grayScale_450,
          ),
        ),
      ),
    );
  }

  /// 여행지 목록 위젯
  Widget _buildDestinationList() {
    return ListView.builder(
      key: const PageStorageKey('destination_list'),
      itemCount: destinations.length,
      itemBuilder: (context, index) {
        final destination = destinations[index];
        final reason = index < reasons.length ? reasons[index] : '';
        final matchPercent = 95 - (index * 10);

        return _buildDestinationListItem(
          destination: destination,
          reason: reason,
          matchPercent: matchPercent,
        );
      },
    );
  }

  /// 여행지 목록 아이템 위젯
  Widget _buildDestinationListItem({
    required String destination,
    required String reason,
    required int matchPercent,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => selectedDestination = destination),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          boxShadow: AppShadow.generalShadow,
          border: Border.all(
            color: selectedDestination == destination
                ? AppColors.primary_450
                : Colors.transparent,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: _buildDestinationCard(
          destination: destination,
          reason: reason,
          matchPercent: matchPercent,
        ),
      ),
    );
  }

  /// 여행지 카드 위젯
  Widget _buildDestinationCard({
    required String destination,
    required String reason,
    required int matchPercent,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDestinationImage(destination),
          _buildDestinationInfo(
            destination: destination,
            reason: reason,
            matchPercent: matchPercent,
          ),
        ],
      ),
    );
  }

  /// 여행지 이미지 위젯
  Widget _buildDestinationImage(String destination) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: SizedBox(
              width: double.infinity,
              child: _buildCachedImage(destination),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: _buildDestinationTags(destination),
          ),
        ],
      ),
    );
  }

  /// 캐시된 이미지 위젯
  Widget _buildCachedImage(String destination) {
    return FutureBuilder<String>(
      future: _getCachedImage(destination),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary_450),
          );
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return Container(
            color: Colors.grey[200],
            child: const Icon(Icons.error),
          );
        }
        return Image.network(
          snapshot.data!,
          fit: BoxFit.cover,
          key: ValueKey(destination),
        );
      },
    );
  }

  /// 여행지 태그 위젯
  Widget _buildDestinationTags(String destination) {
    final tags = getCityTags(
      destination,
      ref.read(recommendationStateProvider).travelStyles,
    )['tags']!;

    return Wrap(
      spacing: 8,
      children: tags.map((tag) => _buildTag(tag)).toList(),
    );
  }

  Widget _buildDestinationInfo({
    required String destination,
    required String reason,
    required int matchPercent,
  }) {
    return Padding(
      padding: AppSpacing.medium16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  destination,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star,
                      color: AppColors.primary_450, size: 16),
                  Text(' $matchPercent% 일치',
                      style: AppTypography.body2.copyWith(
                        color: AppColors.primary_450,
                      )),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 60,
            child: Text(
              reason,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }

  /// 이미지 캐싱을 위한 메서드
  /// 이미 캐시된 이미지가 있으면 해당 이미지를 반환하고,
  /// 없으면 새로 다운로드하여 캐시에 저장
  Future<String> _getCachedImage(String destination) async {
    if (_imageCache.containsKey(destination)) {
      return _imageCache[destination]!;
    }
    final imageUrl = await _getPixabayImage(destination);
    _imageCache[destination] = imageUrl;
    return imageUrl;
  }

  /// Pixabay API를 사용하여 도시 이미지를 가져오는 메서드
  Future<String> _getPixabayImage(String destination) async {
    try {
      final city = destination.split('(')[0].trim();
      final query = Uri.encodeComponent(city);
      final response = await http.get(
        Uri.parse(
          'https://pixabay.com/api/?key=48447680-a9467e6fd874740328fcde2e3&q=$query&image_type=photo&category=travel&orientation=horizontal&per_page=3',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['hits'].isNotEmpty) {
          return data['hits'][0]['webformatURL'];
        }
      }
      throw Exception('이미지를 찾을 수 없습니다');
    } catch (e) {
      throw Exception('이미지 로드 실패: $e');
    }
  }

  /// 도시별 태그 정보를 반환하는 메서드
  /// 기본 태그와 사용자의 여행 스타일에 따른 추가 태그를 조합
  Map<String, List<String>> getCityTags(
      String city, List<String> travelStyles) {
    final tags = <String, List<String>>{
      // 일본
      '도쿄': ['현대적', '쇼핑천국'],
      '오사카': ['맛집여행', '활기찬'],
      '교토': ['전통문화', '고즈넉한'],
      '나라': ['역사유적', '자연친화'],
      '후쿠오카': ['먹방투어', '도시여행'],
      '삿포로': ['시원한 기후', '겨울축제'],

      // 한국
      '서울': ['케이컬처', '트렌디'],
      '부산': ['해양도시', '먹방투어'],
      '제주': ['자연경관', '휴양'],
      '강릉': ['바다여행', '카페거리'],
      '여수': ['밤바다', '해산물'],
      '경주': ['역사유적', '고도'],

      // 동남아시아
      '방콕': ['열대기후', '불교문화'],
      '싱가포르': ['현대도시', '다문화'],
      '발리': ['휴양지', '열대기후'],
      '세부': ['해변휴양', '액티비티'],
      '다낭': ['해변도시', '리조트'],
      '하노이': ['전통문화', '역사적'],

      // 미국
      '뉴욕': ['도시여행', '문화예술'],
      '로스앤젤레스': ['엔터테인먼트', '해변'],
      '샌프란시스코': ['다문화', '베이에리어'],
      '라스베가스': ['카지노', '엔터테인먼트'],
      '하와이': ['휴양지', '열대기후'],

      // 유럽
      '파리': ['예술의도시', '로맨틱'],
      '런던': ['역사문화', '현대적'],
      '로마': ['고대유적', '예술'],
      '바르셀로나': ['건축예술', '지중해'],
      '암스테르담': ['운하도시', '예술'],
      '프라하': ['중세도시', '낭만적'],
      '베니스': ['수상도시', '로맨틱'],
    };

    // 기본 태그 설정
    List<String> cityTags = tags[city] ?? ['도시여행', '관광'];

    // 여행 스타일에 따른 추가 태그
    if (travelStyles.contains('맛집')) {
      cityTags = ['맛집투어', ...cityTags];
    }
    if (travelStyles.contains('쇼핑')) {
      cityTags = ['쇼핑', ...cityTags];
    }

    return {'tags': cityTags.take(2).toList()}; // 최대 2개의 태그만 반환
  }

  Widget _buildBottomButtons(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as SurveyResponse?;
    if (args == null) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide(color: AppColors.primary_450),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: _isAdLoading ? null : () => _showRewardedAd(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!_isAdLoading) ...[
                    SvgPicture.asset(
                      'assets/icons/play.svg',
                      color: AppColors.primary_450,
                      height: 16,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    _isAdLoading ? '광고 로딩 중...' : '다시 추천받기',
                    style: AppTypography.buttonLabelSmall.copyWith(
                      color: AppColors.primary_450,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: StandardButton.primary(
              sizeType: ButtonSizeType.normal,
              onPressed: selectedDestination != null
                  ? () {
                      final updatedSurveyResponse = args.copyWith(
                        selectedCity: selectedDestination,
                      );
                      Navigator.pushNamed(
                        context,
                        '/ai-schedule',
                        arguments: updatedSurveyResponse,
                      );
                    }
                  : null,
              text: '다음으로',
            ),
          ),
        ],
      ),
    );
  }
}
