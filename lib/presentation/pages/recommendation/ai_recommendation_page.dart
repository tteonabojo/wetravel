import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:wetravel/domain/entity/survey_response.dart';
import 'package:wetravel/presentation/provider/recommendation_provider.dart';

class AIRecommendationPage extends ConsumerStatefulWidget {
  const AIRecommendationPage({super.key});

  @override
  ConsumerState<AIRecommendationPage> createState() =>
      _AIRecommendationPageState();
}

class _AIRecommendationPageState extends ConsumerState<AIRecommendationPage> {
  @override
  Widget build(BuildContext context) {
    final surveyResponse =
        ModalRoute.of(context)!.settings.arguments as SurveyResponse;

    return ref.watch(recommendationProvider(surveyResponse)).when(
          data: (recommendation) {
            if (surveyResponse.selectedCity != null) {
              // 선택된 도시가 있는 경우, 같은 카테고리에서 2개 도시 추가
              final recommendedCities = ref
                  .read(recommendationStateProvider.notifier)
                  .getRecommendedCitiesFromSameCategory(
                      surveyResponse.selectedCity!);

              // 기존 destinations를 클리어하고 새로운 순서로 설정
              recommendation.destinations.clear();
              recommendation.destinations.add(surveyResponse.selectedCity!);
              recommendation.destinations.addAll(recommendedCities);

              // reasons와 tips도 적절히 조정
              // (실제 구현에서는 각 도시에 맞는 이유와 팁을 설정해야 함)
            }

            return Scaffold(
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        '맞춤 여행지 추천',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        '설문 결과를 바탕으로 최적의 여행지를 찾았어요',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // 메인 추천 여행지
                      _buildMainDestinationCard(
                        recommendation.destinations[0],
                        recommendation.reasons[0],
                        recommendation.tips[0],
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        '다른 추천 여행지',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // 다른 추천 여행지들을 가로 스크롤로 변경
                      SizedBox(
                        height: 250, // 여유있게 높이 증가
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: recommendation.destinations.length - 1,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                right: 16.0,
                                left: index == 0 ? 0 : 0,
                              ),
                              child: _buildOtherDestinationCard(
                                recommendation.destinations[index + 1],
                                recommendation.reasons[index + 1],
                                95 - (index * 3),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      // 하단 버튼
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // 다시 추천받기 기능
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text('다시 추천받기'),
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                side: const BorderSide(color: Colors.blue),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // 일정 추천받기 기능
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text(
                                '일정 추천받기',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
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

  Widget _buildMainDestinationCard(
      String destination, String reason, String tip) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: FutureBuilder<String>(
                    future: _getPixabayImage(destination),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
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
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '95% 일치',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // 태그 추가
              Positioned(
                bottom: 16,
                left: 16,
                child: Wrap(
                  spacing: 8,
                  children: [
                    _buildTag('따뜻한 기후'),
                    _buildTag('휴양'),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  destination,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  reason,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtherDestinationCard(
      String destination, String reason, int matchPercent) {
    return Container(
      width: 280,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 140,
                    child: FutureBuilder<String>(
                      future: _getPixabayImage(destination),
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
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$matchPercent% 일치',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Flexible(
              // Container를 Flexible로 변경
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      destination,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    LayoutBuilder(
                      // 추가: 텍스트 크기에 맞게 조절
                      builder: (context, constraints) {
                        return Text(
                          reason,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            height: 1.2, // 줄 간격 조정
                          ),
                          maxLines: 3, // 최대 3줄까지 표시
                          overflow: TextOverflow.ellipsis,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
}
