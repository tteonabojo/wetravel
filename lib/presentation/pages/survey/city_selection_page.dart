import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/presentation/provider/recommendation_provider.dart';
import 'package:wetravel/presentation/widgets/buttons/standard_button.dart';
import 'package:wetravel/presentation/provider/survey_provider.dart';

// 국가별 도시 데이터를 클래스 외부로 이동
const Map<String, List<String>> cityCategories = {
  '일본': ['도쿄', '오사카', '시즈오카', '나고야', '삿포로', '후쿠오카', '교토', '나라'],
  '한국': ['서울', '부산', '제주', '강릉', '여수', '경주'],
  '동남아시아': ['방콕', '싱가포르', '발리', '세부', '다낭', '하노이', '호치민', '쿠알라룸푸르'],
  '미국': ['뉴욕', '로스앤젤레스', '샌프란시스코', '라스베가스', '시애틀', '하와이'],
  '유럽': ['파리', '런던', '로마', '바르셀로나', '암스테르담', '프라하', '비엔나', '베니스'],
};

class CitySelectionPage extends ConsumerStatefulWidget {
  const CitySelectionPage({super.key});

  @override
  ConsumerState<CitySelectionPage> createState() => _CitySelectionPageState();
}

class _CitySelectionPageState extends ConsumerState<CitySelectionPage> {
  @override
  void initState() {
    super.initState();
    // 도시 선택 페이지에 진입할 때 완전히 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('Entering city selection - resetting all states');
      // 모든 상태 완전 초기화
      ref.read(surveyProvider.notifier).resetState();
      ref.read(recommendationStateProvider.notifier).resetState();
      ref.invalidate(recommendationProvider);
    });
  }

  void _onCitySelected(BuildContext context, String city) {
    print('Selected city: $city');
    // 사용자가 선택한 도시를 저장
    ref.read(surveyProvider.notifier).setSelectedCity(city);
    print('Verifying city selection: ${ref.read(surveyProvider).selectedCity}');

    // 설문 페이지로 이동 (상태 초기화 없이)
    Navigator.pushReplacementNamed(context, '/survey');
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildCityChip(String city) {
      // surveyProvider의 selectedCity를 확인
      final isSelected = ref.watch(surveyProvider).selectedCity == city;

      return FilterChip(
        label: Text(city),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) {
            _onCitySelected(context, city);
          }
        },
        showCheckmark: false,
        side: BorderSide(style: BorderStyle.none),
        shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.large20),
        backgroundColor: AppColors.grayScale_050,
        selectedColor: AppColors.grayScale_650,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppColors.grayScale_350,
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
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
                value: 0.2,
                backgroundColor: AppColors.grayScale_150,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.primary_450),
              ),
              const SizedBox(height: 30),
              Text(
                '떠나고 싶은\n도시를 선택해주세요',
                style: AppTypography.headline2,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 28),
                      Text(
                        'AI 맞춤 추천',
                        style: AppTypography.headline6.copyWith(
                          color: AppColors.grayScale_650,
                        ),
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/survey');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary_050,
                            borderRadius: AppBorderRadius.large20,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.auto_awesome,
                                  color: AppColors.primary_450, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                'AI로 도시 추천 받을래요',
                                style: AppTypography.buttonLabelSmall.copyWith(
                                  color: AppColors.primary_450,
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
                                style: AppTypography.headline6.copyWith(
                                  color: AppColors.grayScale_650,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 8,
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
                  child: StandardButton.primary(
                      sizeType: ButtonSizeType.normal,
                      onPressed: () {
                        if (ref
                            .read(recommendationStateProvider)
                            .selectedCities
                            .isNotEmpty) {
                          Navigator.pushNamed(context, '/survey');
                        }
                      },
                      text: '다음으로')),
            ],
          ),
        ),
      ),
    );
  }
}
