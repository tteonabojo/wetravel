import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/domain/entity/survey_response.dart';
import 'package:wetravel/presentation/provider/recommendation_provider.dart';
import 'package:wetravel/presentation/widgets/buttons/standard_button.dart';

class SurveyPage extends ConsumerStatefulWidget {
  const SurveyPage({super.key});

  @override
  ConsumerState<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends ConsumerState<SurveyPage> {
  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(recommendationStateProvider);

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
                value: state.currentPage / 3,
                backgroundColor: AppColors.grayScale_150,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.primary_450),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: PageView(
                  controller: pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    TravelPeriodPage(pageController: pageController),
                    TravelStylePage(pageController: pageController),
                    AccommodationPage(pageController: pageController),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: StandardButton.primary(
                    sizeType: ButtonSizeType.normal,
                    onPressed: () {
                      final notifier =
                          ref.read(recommendationStateProvider.notifier);
                      if (notifier.isCurrentPageComplete()) {
                        if (state.currentPage < 2) {
                          notifier.nextPage();
                          pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else if (notifier.isAllOptionsSelected()) {
                          final state = ref.read(recommendationStateProvider);
                          final surveyResponse = SurveyResponse(
                            travelPeriod: state.travelPeriod!,
                            travelDuration: state.travelDuration!,
                            companions: state.companions,
                            travelStyles: state.travelStyles,
                            accommodationTypes: state.accommodationTypes,
                            considerations: state.considerations,
                            selectedCity: state.selectedCities.isNotEmpty
                                ? state.selectedCities.first
                                : null,
                          );

                          Navigator.pushNamed(
                            context,
                            '/plan-selection',
                            arguments: surveyResponse,
                          );
                        }
                      }
                    },
                    text: '다음으로'),
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
  final PageController pageController;

  const TravelPeriodPage({super.key, required this.pageController});

  void _checkAndNavigate(BuildContext context, WidgetRef ref) {
    if (ref
        .read(recommendationStateProvider.notifier)
        .isCurrentPageComplete()) {
      ref.read(recommendationStateProvider.notifier).nextPage();
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(recommendationStateProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '여행 기간은\n어떻게 되시나요?',
            style: AppTypography.headline2,
          ),
          const SizedBox(height: 30),
          Text(
            '여행 시기',
            style: AppTypography.headline6.copyWith(
              color: AppColors.grayScale_650,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              FilterChip(
                label: const Text('일주일 이내'),
                selected: state.travelPeriod == '일주일 이내',
                onSelected: (selected) {
                  if (selected) {
                    ref
                        .read(recommendationStateProvider.notifier)
                        .selectTravelPeriod('일주일 이내');
                    _checkAndNavigate(context, ref);
                  }
                },
              ),
              FilterChip(
                label: const Text('1달 내'),
                selected: state.travelPeriod == '1달 내',
                onSelected: (selected) {
                  if (selected) {
                    ref
                        .read(recommendationStateProvider.notifier)
                        .selectTravelPeriod('1달 내');
                    _checkAndNavigate(context, ref);
                  }
                },
              ),
              FilterChip(
                label: const Text('3개월'),
                selected: state.travelPeriod == '3개월',
                onSelected: (selected) {
                  if (selected) {
                    ref
                        .read(recommendationStateProvider.notifier)
                        .selectTravelPeriod('3개월');
                    _checkAndNavigate(context, ref);
                  }
                },
              ),
              FilterChip(
                label: const Text('일정 계획 없음'),
                selected: state.travelPeriod == '일정 계획 없음',
                onSelected: (selected) {
                  if (selected) {
                    ref
                        .read(recommendationStateProvider.notifier)
                        .selectTravelPeriod('일정 계획 없음');
                    _checkAndNavigate(context, ref);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 30),
          Text(
            '여행 기간',
            style: AppTypography.headline6.copyWith(
              color: AppColors.grayScale_650,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              FilterChip(
                label: const Text('당일치기'),
                selected: state.travelDuration == '당일치기',
                onSelected: (selected) {
                  if (selected) {
                    ref
                        .read(recommendationStateProvider.notifier)
                        .selectTravelDuration('당일치기');
                    _checkAndNavigate(context, ref);
                  }
                },
              ),
              FilterChip(
                label: const Text('1박 2일'),
                selected: state.travelDuration == '1박 2일',
                onSelected: (selected) {
                  if (selected) {
                    ref
                        .read(recommendationStateProvider.notifier)
                        .selectTravelDuration('1박 2일');
                    _checkAndNavigate(context, ref);
                  }
                },
              ),
              FilterChip(
                label: const Text('2박 3일'),
                selected: state.travelDuration == '2박 3일',
                onSelected: (selected) {
                  if (selected) {
                    ref
                        .read(recommendationStateProvider.notifier)
                        .selectTravelDuration('2박 3일');
                    _checkAndNavigate(context, ref);
                  }
                },
              ),
              FilterChip(
                label: const Text('3박 4일'),
                selected: state.travelDuration == '3박 4일',
                onSelected: (selected) {
                  if (selected) {
                    ref
                        .read(recommendationStateProvider.notifier)
                        .selectTravelDuration('3박 4일');
                    _checkAndNavigate(context, ref);
                  }
                },
              ),
              FilterChip(
                label: const Text('4박 5일'),
                selected: state.travelDuration == '4박 5일',
                onSelected: (selected) {
                  if (selected) {
                    ref
                        .read(recommendationStateProvider.notifier)
                        .selectTravelDuration('4박 5일');
                    _checkAndNavigate(context, ref);
                  }
                },
              ),
              FilterChip(
                label: const Text('5박 6일'),
                selected: state.travelDuration == '5박 6일',
                onSelected: (selected) {
                  if (selected) {
                    ref
                        .read(recommendationStateProvider.notifier)
                        .selectTravelDuration('5박 6일');
                    _checkAndNavigate(context, ref);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 여행 스타일 페이지
class TravelStylePage extends ConsumerWidget {
  final PageController pageController;

  const TravelStylePage({super.key, required this.pageController});

  void _checkAndNavigate(BuildContext context, WidgetRef ref) {
    if (ref
        .read(recommendationStateProvider.notifier)
        .isCurrentPageComplete()) {
      ref.read(recommendationStateProvider.notifier).nextPage();
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(recommendationStateProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '어떤 스타일의\n여행을 할 계획인가요?',
            style: AppTypography.headline2,
          ),
          const SizedBox(height: 30),
          Text(
            '누구와',
            style: AppTypography.headline6.copyWith(
              color: AppColors.grayScale_650,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              FilterChip(
                label: const Text('혼자'),
                selected: state.companions.contains('혼자'),
                onSelected: (selected) {
                  if (selected) {
                    ref
                        .read(recommendationStateProvider.notifier)
                        .toggleCompanion('혼자');
                    _checkAndNavigate(context, ref);
                  }
                },
              ),
              FilterChip(
                label: const Text('연인과'),
                selected: state.companions.contains('연인과'),
                onSelected: (selected) {
                  if (selected) {
                    ref
                        .read(recommendationStateProvider.notifier)
                        .toggleCompanion('연인과');
                    _checkAndNavigate(context, ref);
                  }
                },
              ),
              FilterChip(
                label: const Text('친구와'),
                selected: state.companions.contains('친구와'),
                onSelected: (selected) {
                  if (selected) {
                    ref
                        .read(recommendationStateProvider.notifier)
                        .toggleCompanion('친구와');
                    _checkAndNavigate(context, ref);
                  }
                },
              ),
              FilterChip(
                label: const Text('가족과'),
                selected: state.companions.contains('가족과'),
                onSelected: (selected) {
                  if (selected) {
                    ref
                        .read(recommendationStateProvider.notifier)
                        .toggleCompanion('가족과');
                    _checkAndNavigate(context, ref);
                  }
                },
              ),
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
              FilterChip(
                label: const Text('액티비티'),
                selected: state.travelStyles.contains('액티비티'),
                onSelected: (selected) {
                  if (selected) {
                    ref
                        .read(recommendationStateProvider.notifier)
                        .toggleTravelStyle('액티비티');
                    _checkAndNavigate(context, ref);
                  }
                },
              ),
              FilterChip(
                label: const Text('휴양'),
                selected: state.travelStyles.contains('휴양'),
                onSelected: (selected) {
                  if (selected) {
                    ref
                        .read(recommendationStateProvider.notifier)
                        .toggleTravelStyle('휴양');
                    _checkAndNavigate(context, ref);
                  }
                },
              ),
              FilterChip(
                label: const Text('관광지'),
                selected: state.travelStyles.contains('관광지'),
                onSelected: (selected) {
                  if (selected) {
                    ref
                        .read(recommendationStateProvider.notifier)
                        .toggleTravelStyle('관광지');
                    _checkAndNavigate(context, ref);
                  }
                },
              ),
              FilterChip(
                label: const Text('맛집'),
                selected: state.travelStyles.contains('맛집'),
                onSelected: (selected) {
                  if (selected) {
                    ref
                        .read(recommendationStateProvider.notifier)
                        .toggleTravelStyle('맛집');
                    _checkAndNavigate(context, ref);
                  }
                },
              ),
              FilterChip(
                label: const Text('문화/예술/역사'),
                selected: state.travelStyles.contains('문화/예술/역사'),
                onSelected: (selected) {
                  if (selected) {
                    ref
                        .read(recommendationStateProvider.notifier)
                        .toggleTravelStyle('문화/예술/역사');
                    _checkAndNavigate(context, ref);
                  }
                },
              ),
              FilterChip(
                label: const Text('쇼핑'),
                selected: state.travelStyles.contains('쇼핑'),
                onSelected: (selected) {
                  if (selected) {
                    ref
                        .read(recommendationStateProvider.notifier)
                        .toggleTravelStyle('쇼핑');
                    _checkAndNavigate(context, ref);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 숙소 스타일 페이지
class AccommodationPage extends ConsumerWidget {
  final PageController pageController;

  const AccommodationPage({super.key, required this.pageController});

  void _checkAndNavigate(BuildContext context, WidgetRef ref) {
    if (ref
        .read(recommendationStateProvider.notifier)
        .isCurrentPageComplete()) {
      final state = ref.read(recommendationStateProvider);
      final surveyResponse = SurveyResponse(
        travelPeriod: state.travelPeriod!,
        travelDuration: state.travelDuration!,
        companions: state.companions,
        travelStyles: state.travelStyles,
        accommodationTypes: state.accommodationTypes,
        considerations: state.considerations,
        selectedCity:
            state.selectedCities.isNotEmpty ? state.selectedCities.first : null,
      );

      Navigator.pushNamed(
        context,
        '/plan-selection',
        arguments: surveyResponse,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(recommendationStateProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('숙소 스타일과\n고려해야할 사항을 알려주세요',
              style: AppTypography.headline2),
          const SizedBox(height: 30),
          Text(
            '숙소 스타일',
            style: AppTypography.headline6.copyWith(
              color: AppColors.grayScale_650,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              FilterChip(
                label: const Text('호텔'),
                selected: state.accommodationTypes.contains('호텔'),
                onSelected: (selected) {
                  if (selected) {
                    ref
                        .read(recommendationStateProvider.notifier)
                        .toggleAccommodationType('호텔');
                    _checkAndNavigate(context, ref);
                  }
                },
              ),
              FilterChip(
                label: const Text('게스트 하우스'),
                selected: state.accommodationTypes.contains('게스트 하우스'),
                onSelected: (selected) {
                  if (selected) {
                    ref
                        .read(recommendationStateProvider.notifier)
                        .toggleAccommodationType('게스트 하우스');
                    _checkAndNavigate(context, ref);
                  }
                },
              ),
              FilterChip(
                label: const Text('에어비앤비'),
                selected: state.accommodationTypes.contains('에어비앤비'),
                onSelected: (selected) {
                  if (selected) {
                    ref
                        .read(recommendationStateProvider.notifier)
                        .toggleAccommodationType('에어비앤비');
                    _checkAndNavigate(context, ref);
                  }
                },
              ),
              FilterChip(
                label: const Text('캠핑'),
                selected: state.accommodationTypes.contains('캠핑'),
                onSelected: (selected) {
                  if (selected) {
                    ref
                        .read(recommendationStateProvider.notifier)
                        .toggleAccommodationType('캠핑');
                    _checkAndNavigate(context, ref);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 30),
          Text(
            '고려사항',
            style: AppTypography.headline6.copyWith(
              color: AppColors.grayScale_650,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              FilterChip(
                label: const Text('가성비'),
                selected: state.considerations.contains('가성비'),
                onSelected: (selected) {
                  if (selected) {
                    ref
                        .read(recommendationStateProvider.notifier)
                        .toggleConsideration('가성비');
                    _checkAndNavigate(context, ref);
                  }
                },
              ),
              FilterChip(
                label: const Text('시설'),
                selected: state.considerations.contains('시설'),
                onSelected: (selected) {
                  if (selected) {
                    ref
                        .read(recommendationStateProvider.notifier)
                        .toggleConsideration('시설');
                    _checkAndNavigate(context, ref);
                  }
                },
              ),
              FilterChip(
                label: const Text('위치'),
                selected: state.considerations.contains('위치'),
                onSelected: (selected) {
                  if (selected) {
                    ref
                        .read(recommendationStateProvider.notifier)
                        .toggleConsideration('위치');
                    _checkAndNavigate(context, ref);
                  }
                },
              ),
              FilterChip(
                label: const Text('청결'),
                selected: state.considerations.contains('청결'),
                onSelected: (selected) {
                  if (selected) {
                    ref
                        .read(recommendationStateProvider.notifier)
                        .toggleConsideration('청결');
                    _checkAndNavigate(context, ref);
                  }
                },
              ),
              FilterChip(
                label: const Text('기온'),
                selected: state.considerations.contains('기온'),
                onSelected: (selected) {
                  if (selected) {
                    ref
                        .read(recommendationStateProvider.notifier)
                        .toggleConsideration('기온');
                    _checkAndNavigate(context, ref);
                  }
                },
              ),
              FilterChip(
                label: const Text('시차'),
                selected: state.considerations.contains('시차'),
                onSelected: (selected) {
                  if (selected) {
                    ref
                        .read(recommendationStateProvider.notifier)
                        .toggleConsideration('시차');
                    _checkAndNavigate(context, ref);
                  }
                },
              ),
              FilterChip(
                label: const Text('없음'),
                selected: state.considerations.contains('없음'),
                onSelected: (selected) {
                  if (selected) {
                    ref
                        .read(recommendationStateProvider.notifier)
                        .toggleConsideration('없음');
                    _checkAndNavigate(context, ref);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
