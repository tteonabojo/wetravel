import 'dart:convert';
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

class AIRecommendationPage extends ConsumerStatefulWidget {
  const AIRecommendationPage({super.key});

  @override
  ConsumerState<AIRecommendationPage> createState() =>
      _AIRecommendationPageState();
}

class _AIRecommendationPageState extends ConsumerState<AIRecommendationPage> {
  String? selectedDestination;
  final Map<String, String> _imageCache = {};
  List<String> destinations = [];
  List<String> reasons = [];

  Future<String> _getCachedImage(String destination) async {
    if (_imageCache.containsKey(destination)) {
      return _imageCache[destination]!;
    }
    final imageUrl = await _getPixabayImage(destination);
    _imageCache[destination] = imageUrl;
    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    final surveyResponse =
        ModalRoute.of(context)!.settings.arguments as SurveyResponse;

    return ref.watch(recommendationProvider(surveyResponse)).when(
          data: (recommendation) {
            if (recommendation.destinations.isNotEmpty &&
                destinations.isEmpty) {
              if (surveyResponse.selectedCity != null) {
                final recommendedCities = ref
                    .read(recommendationStateProvider.notifier)
                    .getRecommendedCitiesFromSameCategory(
                        surveyResponse.selectedCity!);

                destinations = [
                  surveyResponse.selectedCity!,
                  ...recommendedCities
                ];

                if (recommendation.reasons.isNotEmpty) {
                  final maxLength =
                      destinations.length < recommendation.reasons.length
                          ? destinations.length
                          : recommendation.reasons.length;
                  reasons = recommendation.reasons.sublist(0, maxLength);
                } else {
                  reasons = List.generate(
                    destinations.length,
                    (index) => '추천 여행지입니다.',
                  );
                }
              } else {
                destinations = List.from(recommendation.destinations);
                reasons = recommendation.reasons.isNotEmpty
                    ? List.from(recommendation.reasons)
                    : List.generate(
                        destinations.length,
                        (index) => '추천 여행지입니다.',
                      );
              }
            }

            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: Text(
                  'AI 맞춤 여행지 추천',
                  style: AppTypography.headline4.copyWith(
                    color: AppColors.grayScale_950,
                  ),
                ),
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    icon: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: const Icon(Icons.close),
                    ),
                    onPressed: () => Navigator.pushNamed(context, '/'),
                  ),
                ],
              ),
              body: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        width: double.infinity,
                        padding: AppSpacing.medium16,
                        decoration: BoxDecoration(
                            color: AppColors.grayScale_050,
                            borderRadius: AppBorderRadius.small12),
                        child: Text('리스트를 확인하고 나에게 맞는 여행지를 선택해주세요',
                            style: AppTypography.body2.copyWith(
                              color: AppColors.grayScale_450,
                            )),
                      ),
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        key: const PageStorageKey('destination_list'),
                        itemCount: destinations.length,
                        itemBuilder: (context, index) {
                          final destination = destinations[index];
                          final reason = reasons[index];
                          final matchPercent = 95 - (index * 10);

                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              setState(() {
                                selectedDestination = destination;
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 16.0),
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
                                  destination,
                                  reason,
                                  matchPercent,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                              child: StandardButton.secondary(
                            sizeType: ButtonSizeType.normal,
                            onPressed: () {
                              // TODO 다시 추천받기 기능 넣을것
                            },
                            text: '다시 추천받기',
                          )),
                          const SizedBox(width: 16),
                          Expanded(
                              child: StandardButton.primary(
                                  sizeType: ButtonSizeType.normal,
                                  onPressed: selectedDestination != null
                                      ? () {
                                          // 선택된 도시로 SurveyResponse 업데이트
                                          final updatedSurveyResponse =
                                              surveyResponse.copyWith(
                                            selectedCity: selectedDestination,
                                          );

                                          Navigator.pushNamed(
                                            context,
                                            '/ai-schedule',
                                            arguments: updatedSurveyResponse,
                                          );
                                        }
                                      : null,
                                  text: '다음으로')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          loading: () => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stack) => Scaffold(
            body: Center(child: Text('Error: $error')),
          ),
        );
  }

  Widget _buildDestinationCard(
      String destination, String reason, int matchPercent) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: FutureBuilder<String>(
                      future: _getCachedImage(destination),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
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
                    ),
                  ),
                ),
                // 태그들
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Wrap(
                    spacing: 8,
                    children: getCityTags(
                            destination,
                            ref
                                .read(recommendationStateProvider)
                                .travelStyles)['tags']!
                        .map((tag) => _buildTag(tag))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
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

  // 여행지별 태그 매핑을 추가
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
}
