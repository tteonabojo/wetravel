import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:wetravel/domain/entity/survey_response.dart';
import 'package:wetravel/presentation/providers/recommendation_provider.dart';

class AIRecommendationPage extends ConsumerWidget {
  final SurveyResponse survey;

  const AIRecommendationPage({
    super.key,
    required this.survey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendationAsync = ref.watch(recommendationProvider(survey));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: recommendationAsync.when(
          data: (recommendation) {
            final mainDestination = recommendation.destinations.first;
            final mainReason = recommendation.reasons.first;
            final mainTip = recommendation.tips.first;

            final otherDestinations = recommendation.destinations.sublist(1);
            final otherReasons = recommendation.reasons.sublist(1);
            final otherTips = recommendation.tips.sublist(1);

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '맞춤 여행지 추천',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '설문 결과를 바탕으로 최적의 여행지를 찾았어요',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // 메인 추천 여행지
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: DestinationCard(
                            destination: mainDestination,
                            reason: mainReason,
                            tip: mainTip,
                          ),
                        ),
                        // 다른 추천 여행지들
                        const Padding(
                          padding: EdgeInsets.only(left: 16.0, top: 8.0),
                          child: Text(
                            '다른 추천 여행지',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 320,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.all(16),
                            itemCount: otherDestinations.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: SizedBox(
                                  width: 280,
                                  child: SmallDestinationCard(
                                    destination: otherDestinations[index],
                                    reason: otherReasons[index],
                                    tip: otherTips[index],
                                    index: index,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16), // 하단 여백 추가
                      ],
                    ),
                  ),
                ),
                // 하단 버튼
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // TODO: 다시 추천받기 기능 구현
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.refresh),
                              SizedBox(width: 8),
                              Text('다시 추천받기'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            // TODO: 일정 생성하기 기능 구현
                          },
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('일정 생성하기'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text('오류가 발생했습니다: $error'),
          ),
        ),
      ),
    );
  }
}

class DestinationCard extends StatelessWidget {
  final String destination;
  final String reason;
  final String tip;

  const DestinationCard({
    super.key,
    required this.destination,
    required this.reason,
    required this.tip,
  });

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

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                children: [
                  FutureBuilder<String>(
                    future: _getPixabayImage(destination),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (snapshot.hasError || !snapshot.hasData) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.error_outline,
                            color: Colors.grey,
                            size: 48,
                          ),
                        );
                      }

                      return Image.network(
                        snapshot.data!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      );
                    },
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
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
                ],
              ),
            ),
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
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.lightbulb_outline,
                        color: Colors.blue,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          tip,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 작은 카드용 새로운 위젯
class SmallDestinationCard extends StatelessWidget {
  final String destination;
  final String reason;
  final String tip;
  final int index;

  const SmallDestinationCard({
    super.key,
    required this.destination,
    required this.reason,
    required this.tip,
    required this.index,
  });

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

  String _getMatchRate() {
    return index == 0 ? '88% 일치' : '82% 일치';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                children: [
                  FutureBuilder<String>(
                    future: _getPixabayImage(destination),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (snapshot.hasError || !snapshot.hasData) {
                        return Container(
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.error_outline,
                            color: Colors.grey,
                            size: 32,
                          ),
                        );
                      }

                      return Image.network(
                        snapshot.data!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      );
                    },
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _getMatchRate(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                Text(
                  reason,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                    height: 1.3,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
