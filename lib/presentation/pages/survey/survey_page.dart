import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/domain/entity/survey_response.dart';
import 'package:wetravel/presentation/provider/recommendation_provider.dart';

class SurveyPage extends ConsumerStatefulWidget {
  const SurveyPage({super.key});

  static final pageController = PageController();

  @override
  ConsumerState<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends ConsumerState<SurveyPage> {
  @override
  Widget build(BuildContext context) {
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
                value: ref.watch(recommendationStateProvider).currentPage / 3,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: PageView(
                  controller: SurveyPage.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    TravelPeriodPage(),
                    TravelStylePage(),
                    AccommodationPage(),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (ref
                        .read(recommendationStateProvider.notifier)
                        .isAllOptionsSelected()) {
                      if (ref.read(recommendationStateProvider).currentPage <
                          2) {
                        ref
                            .read(recommendationStateProvider.notifier)
                            .nextPage();
                      } else {
                        final surveyState =
                            ref.read(recommendationStateProvider);
                        final selectedCity =
                            surveyState.selectedCities.isNotEmpty
                                ? surveyState.selectedCities.first
                                : null;

                        final surveyResponse = SurveyResponse(
                          travelPeriod: surveyState.travelPeriod ?? '',
                          travelDuration: surveyState.travelDuration ?? '',
                          companions: surveyState.companions,
                          travelStyles: surveyState.travelStyles,
                          accommodationTypes: surveyState.accommodationTypes,
                          considerations: surveyState.considerations,
                          selectedCity: selectedCity,
                        );

                        Navigator.pushNamed(context, '/plan-selection');
                      }
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

// 여행 기간 페이지
class TravelPeriodPage extends ConsumerWidget {
  const TravelPeriodPage({super.key});

  void _checkAndNavigate(BuildContext context, WidgetRef ref) {
    final state = ref.read(recommendationStateProvider);
    if (state.travelPeriod != null && state.travelDuration != null) {
      ref.read(recommendationStateProvider.notifier).nextPage();
      SurveyPage.pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '여행 기간은\n어떻게 되시나요?',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 30),
        const Text(
          '여행 시기',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _buildSelectionChip('일주일 이내',
                ref.watch(recommendationStateProvider).travelPeriod == '일주일 이내',
                (selected) {
              ref
                  .read(recommendationStateProvider.notifier)
                  .selectTravelPeriod('일주일 이내');
              _checkAndNavigate(context, ref);
            }),
            _buildSelectionChip('1달 내',
                ref.watch(recommendationStateProvider).travelPeriod == '1달 내',
                (selected) {
              ref
                  .read(recommendationStateProvider.notifier)
                  .selectTravelPeriod('1달 내');
              _checkAndNavigate(context, ref);
            }),
            _buildSelectionChip('3개월',
                ref.watch(recommendationStateProvider).travelPeriod == '3개월',
                (selected) {
              ref
                  .read(recommendationStateProvider.notifier)
                  .selectTravelPeriod('3개월');
              _checkAndNavigate(context, ref);
            }),
            _buildSelectionChip(
                '일정 계획 없음',
                ref.watch(recommendationStateProvider).travelPeriod ==
                    '일정 계획 없음', (selected) {
              ref
                  .read(recommendationStateProvider.notifier)
                  .selectTravelPeriod('일정 계획 없음');
              _checkAndNavigate(context, ref);
            }),
          ],
        ),
        const SizedBox(height: 30),
        const Text(
          '여행 기간',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _buildSelectionChip('당일치기',
                ref.watch(recommendationStateProvider).travelDuration == '당일치기',
                (selected) {
              ref
                  .read(recommendationStateProvider.notifier)
                  .selectTravelDuration('당일치기');
              _checkAndNavigate(context, ref);
            }),
            _buildSelectionChip(
                '1박 2일',
                ref.watch(recommendationStateProvider).travelDuration ==
                    '1박 2일', (selected) {
              ref
                  .read(recommendationStateProvider.notifier)
                  .selectTravelDuration('1박 2일');
              _checkAndNavigate(context, ref);
            }),
            _buildSelectionChip(
                '2박 3일',
                ref.watch(recommendationStateProvider).travelDuration ==
                    '2박 3일', (selected) {
              ref
                  .read(recommendationStateProvider.notifier)
                  .selectTravelDuration('2박 3일');
              _checkAndNavigate(context, ref);
            }),
            _buildSelectionChip(
                '3박 4일',
                ref.watch(recommendationStateProvider).travelDuration ==
                    '3박 4일', (selected) {
              ref
                  .read(recommendationStateProvider.notifier)
                  .selectTravelDuration('3박 4일');
              _checkAndNavigate(context, ref);
            }),
            _buildSelectionChip(
                '4박 5일',
                ref.watch(recommendationStateProvider).travelDuration ==
                    '4박 5일', (selected) {
              ref
                  .read(recommendationStateProvider.notifier)
                  .selectTravelDuration('4박 5일');
              _checkAndNavigate(context, ref);
            }),
            _buildSelectionChip(
                '5박 6일',
                ref.watch(recommendationStateProvider).travelDuration ==
                    '5박 6일', (selected) {
              ref
                  .read(recommendationStateProvider.notifier)
                  .selectTravelDuration('5박 6일');
              _checkAndNavigate(context, ref);
            }),
            _buildSelectionChip('그 이상',
                ref.watch(recommendationStateProvider).travelDuration == '그 이상',
                (selected) {
              ref
                  .read(recommendationStateProvider.notifier)
                  .selectTravelDuration('그 이상');
              _checkAndNavigate(context, ref);
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildSelectionChip(
      String label, bool isSelected, Function(bool) onSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      backgroundColor: Colors.grey[200],
      selectedColor: Colors.grey[600],
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
      ),
    );
  }
}

// 여행 스타일 페이지
class TravelStylePage extends ConsumerWidget {
  const TravelStylePage({super.key});

  void _checkAndNavigate(BuildContext context, WidgetRef ref) {
    if (ref.read(recommendationStateProvider.notifier).isAllOptionsSelected()) {
      ref.read(recommendationStateProvider.notifier).nextPage();
      SurveyPage.pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '어떤 스타일의\n여행을 할 계획인가요?',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 30),
        const Text(
          '누구와',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _buildSelectionChip(
                '혼자',
                ref
                    .watch(recommendationStateProvider)
                    .companions
                    .contains('혼자'), (selected) {
              ref
                  .read(recommendationStateProvider.notifier)
                  .toggleCompanion('혼자');
              _checkAndNavigate(context, ref);
            }),
            _buildSelectionChip(
                '연인과',
                ref
                    .watch(recommendationStateProvider)
                    .companions
                    .contains('연인과'), (selected) {
              ref
                  .read(recommendationStateProvider.notifier)
                  .toggleCompanion('연인과');
              _checkAndNavigate(context, ref);
            }),
            _buildSelectionChip(
                '친구와',
                ref
                    .watch(recommendationStateProvider)
                    .companions
                    .contains('친구와'), (selected) {
              ref
                  .read(recommendationStateProvider.notifier)
                  .toggleCompanion('친구와');
              _checkAndNavigate(context, ref);
            }),
            _buildSelectionChip(
                '가족과',
                ref
                    .watch(recommendationStateProvider)
                    .companions
                    .contains('가족과'), (selected) {
              ref
                  .read(recommendationStateProvider.notifier)
                  .toggleCompanion('가족과');
              _checkAndNavigate(context, ref);
            }),
          ],
        ),
        const SizedBox(height: 30),
        const Text(
          '여행 스타일',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _buildSelectionChip(
                '액티비티',
                ref
                    .watch(recommendationStateProvider)
                    .travelStyles
                    .contains('액티비티'), (selected) {
              ref
                  .read(recommendationStateProvider.notifier)
                  .toggleTravelStyle('액티비티');
              _checkAndNavigate(context, ref);
            }),
            _buildSelectionChip(
                '휴양',
                ref
                    .watch(recommendationStateProvider)
                    .travelStyles
                    .contains('휴양'), (selected) {
              ref
                  .read(recommendationStateProvider.notifier)
                  .toggleTravelStyle('휴양');
              _checkAndNavigate(context, ref);
            }),
            _buildSelectionChip(
                '관광지',
                ref
                    .watch(recommendationStateProvider)
                    .travelStyles
                    .contains('관광지'), (selected) {
              ref
                  .read(recommendationStateProvider.notifier)
                  .toggleTravelStyle('관광지');
              _checkAndNavigate(context, ref);
            }),
            _buildSelectionChip(
                '맛집',
                ref
                    .watch(recommendationStateProvider)
                    .travelStyles
                    .contains('맛집'), (selected) {
              ref
                  .read(recommendationStateProvider.notifier)
                  .toggleTravelStyle('맛집');
              _checkAndNavigate(context, ref);
            }),
            _buildSelectionChip(
                '문화/예술/역사',
                ref
                    .watch(recommendationStateProvider)
                    .travelStyles
                    .contains('문화/예술/역사'), (selected) {
              ref
                  .read(recommendationStateProvider.notifier)
                  .toggleTravelStyle('문화/예술/역사');
              _checkAndNavigate(context, ref);
            }),
            _buildSelectionChip(
                '쇼핑',
                ref
                    .watch(recommendationStateProvider)
                    .travelStyles
                    .contains('쇼핑'), (selected) {
              ref
                  .read(recommendationStateProvider.notifier)
                  .toggleTravelStyle('쇼핑');
              _checkAndNavigate(context, ref);
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildSelectionChip(
      String label, bool isSelected, Function(bool) onSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      backgroundColor: Colors.grey[200],
      selectedColor: Colors.grey[600],
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
      ),
    );
  }
}

// 숙소 스타일 페이지
class AccommodationPage extends ConsumerWidget {
  const AccommodationPage({super.key});

  void _checkAndNavigate(BuildContext context, WidgetRef ref) {
    if (ref.read(recommendationStateProvider.notifier).isAllOptionsSelected()) {
      Navigator.pushReplacementNamed(context, '/plan-selection');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '숙소 스타일과\n고려해야할 사항을 알려주세요',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 30),
        const Text(
          '숙소 스타일',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _buildSelectionChip(
                '호텔',
                ref
                    .watch(recommendationStateProvider)
                    .accommodationTypes
                    .contains('호텔'), (selected) {
              ref
                  .read(recommendationStateProvider.notifier)
                  .toggleAccommodationType('호텔');
              _checkAndNavigate(context, ref);
            }),
            _buildSelectionChip(
                '게스트 하우스',
                ref
                    .watch(recommendationStateProvider)
                    .accommodationTypes
                    .contains('게스트 하우스'), (selected) {
              ref
                  .read(recommendationStateProvider.notifier)
                  .toggleAccommodationType('게스트 하우스');
              _checkAndNavigate(context, ref);
            }),
            _buildSelectionChip(
                '에어비앤비',
                ref
                    .watch(recommendationStateProvider)
                    .accommodationTypes
                    .contains('에어비앤비'), (selected) {
              ref
                  .read(recommendationStateProvider.notifier)
                  .toggleAccommodationType('에어비앤비');
              _checkAndNavigate(context, ref);
            }),
            _buildSelectionChip(
                '캠핑',
                ref
                    .watch(recommendationStateProvider)
                    .accommodationTypes
                    .contains('캠핑'), (selected) {
              ref
                  .read(recommendationStateProvider.notifier)
                  .toggleAccommodationType('캠핑');
              _checkAndNavigate(context, ref);
            }),
          ],
        ),
        const SizedBox(height: 30),
        const Text(
          '고려사항',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _buildSelectionChip(
                '가성비',
                ref
                    .watch(recommendationStateProvider)
                    .considerations
                    .contains('가성비'), (selected) {
              ref
                  .read(recommendationStateProvider.notifier)
                  .toggleConsideration('가성비');
              _checkAndNavigate(context, ref);
            }),
            _buildSelectionChip(
                '시설',
                ref
                    .watch(recommendationStateProvider)
                    .considerations
                    .contains('시설'), (selected) {
              ref
                  .read(recommendationStateProvider.notifier)
                  .toggleConsideration('시설');
              _checkAndNavigate(context, ref);
            }),
            _buildSelectionChip(
                '위치',
                ref
                    .watch(recommendationStateProvider)
                    .considerations
                    .contains('위치'), (selected) {
              ref
                  .read(recommendationStateProvider.notifier)
                  .toggleConsideration('위치');
              _checkAndNavigate(context, ref);
            }),
            _buildSelectionChip(
                '청결',
                ref
                    .watch(recommendationStateProvider)
                    .considerations
                    .contains('청결'), (selected) {
              ref
                  .read(recommendationStateProvider.notifier)
                  .toggleConsideration('청결');
              _checkAndNavigate(context, ref);
            }),
            _buildSelectionChip(
                '기온',
                ref
                    .watch(recommendationStateProvider)
                    .considerations
                    .contains('기온'), (selected) {
              ref
                  .read(recommendationStateProvider.notifier)
                  .toggleConsideration('기온');
              _checkAndNavigate(context, ref);
            }),
            _buildSelectionChip(
                '시차',
                ref
                    .watch(recommendationStateProvider)
                    .considerations
                    .contains('시차'), (selected) {
              ref
                  .read(recommendationStateProvider.notifier)
                  .toggleConsideration('시차');
              _checkAndNavigate(context, ref);
            }),
            _buildSelectionChip(
                '없음',
                ref
                    .watch(recommendationStateProvider)
                    .considerations
                    .contains('없음'), (selected) {
              ref
                  .read(recommendationStateProvider.notifier)
                  .toggleConsideration('없음');
              _checkAndNavigate(context, ref);
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildSelectionChip(
      String label, bool isSelected, Function(bool) onSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      backgroundColor: Colors.grey[200],
      selectedColor: Colors.grey[600],
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
      ),
    );
  }
}
