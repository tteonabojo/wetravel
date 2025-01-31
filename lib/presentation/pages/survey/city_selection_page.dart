import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/presentation/provider/recommendation_provider.dart';

class CitySelectionPage extends ConsumerWidget {
  const CitySelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              const Text(
                '떠나고 싶은\n도시를 선택해주세요',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/survey');
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          size: 16,
                          color: Colors.blue[700],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'ai 맞춤 추천',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCitySection(
                          '일본',
                          [
                            '도쿄',
                            '오사카',
                            '시즈오카',
                            '나고야',
                            '삿포로',
                            '후쿠오카',
                            '교토',
                            '나라',
                          ],
                          ref,
                          context),
                      _buildCitySection(
                          '한국',
                          [
                            '서울',
                            '부산',
                            '제주',
                            '강릉',
                            '여수',
                            '경주',
                          ],
                          ref,
                          context),
                      _buildCitySection(
                          '동남아시아',
                          [
                            '방콕',
                            '싱가포르',
                            '발리',
                            '세부',
                            '다낭',
                            '하노이',
                            '호치민',
                            '쿠알라룸푸르',
                          ],
                          ref,
                          context),
                      _buildCitySection(
                          '미국',
                          [
                            '뉴욕',
                            '로스앤젤레스',
                            '샌프란시스코',
                            '라스베가스',
                            '시애틀',
                            '하와이',
                          ],
                          ref,
                          context),
                      _buildCitySection(
                          '유럽',
                          [
                            '파리',
                            '런던',
                            '로마',
                            '바르셀로나',
                            '암스테르담',
                            '프라하',
                            '비엔나',
                            '베니스',
                          ],
                          ref,
                          context),
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
                      final selectedCity = ref
                          .read(recommendationStateProvider)
                          .selectedCities
                          .first;

                      ref.read(recommendationStateProvider.notifier).setState(
                            selectedCity: selectedCity,
                          );

                      Navigator.pushNamed(context, '/plan-selection');
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

  Widget _buildCitySection(
      String region, List<String> cities, WidgetRef ref, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            region,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: cities.map((city) {
            final isSelected = ref
                .watch(recommendationStateProvider)
                .selectedCities
                .contains(city);
            return ChoiceChip(
              label: Text(city),
              selected: isSelected,
              onSelected: (selected) {
                ref.read(recommendationStateProvider.notifier).toggleCity(city);
                if (selected) {
                  ref.read(recommendationStateProvider.notifier).setState(
                        selectedCity: city,
                      );
                  Navigator.pushNamed(context, '/survey');
                }
              },
              backgroundColor: Colors.grey[200],
              selectedColor: Colors.blue,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
