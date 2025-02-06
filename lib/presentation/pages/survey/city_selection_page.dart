import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/presentation/provider/recommendation_provider.dart';
import 'package:wetravel/domain/entity/survey_response.dart';
import 'package:flutter/foundation.dart' as dev;

// 국가별 도시 데이터를 클래스 외부로 이동
const Map<String, List<String>> cityCategories = {
  '일본': ['도쿄', '오사카', '시즈오카', '나고야', '삿포로', '후쿠오카', '교토', '나라'],
  '한국': ['서울', '부산', '제주', '강릉', '여수', '경주'],
  '동남아시아': ['방콕', '싱가포르', '발리', '세부', '다낭', '하노이', '호치민', '쿠알라룸푸르'],
  '미국': ['뉴욕', '로스앤젤레스', '샌프란시스코', '라스베가스', '시애틀', '하와이'],
  '유럽': ['파리', '런던', '로마', '바르셀로나', '암스테르담', '프라하', '비엔나', '베니스'],
};

class CitySelectionPage extends ConsumerWidget {
  const CitySelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void _onCitySelected(BuildContext context, String city) {
      // 선택된 도시만 설정하고 나머지는 초기화
      ref.read(recommendationStateProvider.notifier).resetState(
            selectedCity: city,
          );

      Navigator.pushNamed(
        context,
        '/survey',
        arguments: SurveyResponse(
          travelPeriod: '',
          travelDuration: '',
          companions: const [],
          travelStyles: const [],
          accommodationTypes: const [],
          considerations: const [],
          selectedCity: city,
        ),
      );
    }

    Widget _buildCityChip(String city) {
      final isSelected =
          ref.watch(recommendationStateProvider).selectedCities.contains(city);

      return FilterChip(
        label: Text(city),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) {
            ref.read(recommendationStateProvider.notifier).toggleCity(city);
            _onCitySelected(context, city);
          }
        },
        backgroundColor: Colors.grey[200],
        selectedColor: Colors.grey[600],
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 20),
              LinearProgressIndicator(
                value: 0.25,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              const SizedBox(height: 30),
              const Text(
                '떠나고 싶은\n도시를 선택해주세요',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'AI 맞춤 추천',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/survey');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.auto_awesome,
                                  color: Colors.blue[700], size: 16),
                              const SizedBox(width: 4),
                              Text(
                                'AI로 도시 추천 받을래요',
                                style: TextStyle(
                                  color: Colors.blue[700],
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // 각 국가 카테고리별 도시 목록
                      ...cityCategories.entries.map((entry) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 30),
                              Text(
                                entry.key,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: entry.value
                                    .map((city) => _buildCityChip(city))
                                    .toList(),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (ref
                        .read(recommendationStateProvider)
                        .selectedCities
                        .isNotEmpty) {
                      Navigator.pushNamed(context, '/survey');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    '다음으로',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
