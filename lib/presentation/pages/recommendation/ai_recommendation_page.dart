import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:wetravel/domain/entity/survey_response.dart';
import 'package:wetravel/presentation/pages/stack/stack_page.dart';
import 'package:wetravel/presentation/provider/recommendation_provider.dart';
import 'package:wetravel/domain/entity/schedule.dart';
import 'package:wetravel/presentation/provider/user_provider.dart';

class AIRecommendationPage extends ConsumerStatefulWidget {
  const AIRecommendationPage({super.key});

  @override
  ConsumerState<AIRecommendationPage> createState() =>
      _AIRecommendationPageState();
}

class _AIRecommendationPageState extends ConsumerState<AIRecommendationPage> {
  String? selectedDestination;
  late SurveyResponse surveyResponse;

  @override
  Widget build(BuildContext context) {
    surveyResponse =
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

              // 각 도시에 맞는 이유 설정
              recommendation.reasons = recommendation.destinations.map((city) {
                final tags = ref
                    .read(recommendationStateProvider.notifier)
                    .getCityTags(city, surveyResponse.travelStyles)['tags']!;
                return '${city}는 ${tags.join(', ')} 등의 특징이 있어 추천드립니다.';
              }).toList();
            }

            return Scaffold(
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const StackPage(initialIndex: 1),
                            ),
                            (route) => false,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'AI 맞춤 여행지 추천',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '리스트를 확인하고 나에게 맞는 여행지를 한 가지 선택해주세요',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
                          itemCount: recommendation.destinations.length,
                          itemBuilder: (context, index) {
                            final destination =
                                recommendation.destinations[index];
                            final reason = recommendation.reasons[index];
                            final matchPercent =
                                95 - (index * 10); // 순위에 따라 매칭률 감소

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedDestination = destination;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: selectedDestination == destination
                                          ? Colors.blue
                                          : Colors.transparent,
                                      width: 2,
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
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                // 다시 추천받기 기능
                              },
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text('다시 추천받기'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: selectedDestination != null
                                  ? () {
                                      _navigateToSchedule();
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text(
                                '다음으로',
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

  Widget _buildDestinationCard(
      String destination, String reason, int matchPercent) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
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
                // 태그들
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Wrap(
                    spacing: 8,
                    children: ref
                        .read(recommendationStateProvider.notifier)
                        .getCityTags(
                            destination, surveyResponse.travelStyles)['tags']!
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
                        const Icon(Icons.star, color: Colors.blue, size: 16),
                        Text(
                          ' $matchPercent% 일치',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
      // 이미지를 찾지 못한 경우 기본 이미지 URL 반환
      return 'https://via.placeholder.com/640x480?text=No+Image';
    } catch (e) {
      // 에러 발생 시 기본 이미지 URL 반환
      return 'https://via.placeholder.com/640x480?text=Error';
    }
  }

  Future<void> _navigateToSchedule() async {
    final updatedSurveyResponse = surveyResponse.copyWith(
      selectedCity: selectedDestination,
    );
    Navigator.pushNamed(
      context,
      '/ai-schedule',
      arguments: updatedSurveyResponse,
    );
  }
}
