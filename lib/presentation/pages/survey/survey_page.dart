import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/presentation/provider/survey_provider.dart';
import 'package:wetravel/presentation/widgets/buttons/standard_button.dart';

/// 설문 페이지
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentCity = ref.read(surveyProvider).selectedCity;
      ref.read(surveyProvider.notifier).resetStateKeepingCity(currentCity);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(surveyProvider);

    // 현재 페이지에 따른 진행률 계산
    double progressValue =
        1 / 3 + (state.currentPage * 1 / 6); // 1/3 시작, 각 단계마다 1/6 증가

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
                onPressed: () {
                  if (state.currentPage > 0) {
                    ref
                        .read(surveyProvider.notifier)
                        .setCurrentPage(state.currentPage - 1);
                    pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    Navigator.pushReplacementNamed(context, '/city-selection');
                  }
                },
              ),
              const SizedBox(height: 20),
              LinearProgressIndicator(
                value: progressValue, // 동적으로 진행률 설정
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
                    if (!state.isCurrentPageComplete()) {
                      String message = '';
                      switch (state.currentPage) {
                        case 0:
                          if (state.travelPeriod == null &&
                              state.travelDuration == null) {
                            message = '여행 시기와 기간을 선택해주세요.';
                          } else if (state.travelPeriod == null) {
                            message = '여행 시기를 선택해주세요.';
                          } else {
                            message = '여행 기간을 선택해주세요.';
                          }
                          break;
                        case 1:
                          if (state.companion == null &&
                              state.travelStyle == null) {
                            message = '동행인과 여행 스타일을 선택해주세요.';
                          } else if (state.companion == null) {
                            message = '동행인을 선택해주세요.';
                          } else {
                            message = '여행 스타일을 선택해주세요.';
                          }
                          break;
                        case 2:
                          if (state.accommodationType == null &&
                              state.consideration == null) {
                            message = '숙소 스타일과 고려사항을 선택해주세요.';
                          } else if (state.accommodationType == null) {
                            message = '숙소 스타일을 선택해주세요.';
                          } else {
                            message = '고려사항을 선택해주세요.';
                          }
                          break;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(message),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                      return;
                    }
                    _onNextPressed(state);
                  },
                  text: '다음으로',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 다음 버튼 처리
  void _onNextPressed(SurveyState state) {
    if (state.currentPage < 2) {
      ref.read(surveyProvider.notifier).nextPage();
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      final surveyResponse = state.toSurveyResponse();
      Navigator.pushNamed(
        context,
        '/plan-selection',
        arguments: surveyResponse,
      );
    }
  }
}

class SurveyChipList extends StatelessWidget {
  final List<String> items;
  final String selectedItem;
  final Function(String) onSelected;

  const SurveyChipList({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: items.map((item) {
        final isSelected = item == selectedItem;
        return FilterChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSelected) ...[
                const Icon(Icons.check, size: 16, color: Colors.white),
                const SizedBox(width: 4),
              ],
              Text(item),
            ],
          ),
          selected: isSelected,
          onSelected: (_) => onSelected(item), // 항상 선택 가능하도록
          showCheckmark: false,
          side: const BorderSide(style: BorderStyle.none),
          shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.large20),
          backgroundColor: AppColors.grayScale_050,
          selectedColor: AppColors.grayScale_650,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : AppColors.grayScale_350,
          ),
        );
      }).toList(),
    );
  }
}

class SurveySectionTitle extends StatelessWidget {
  final String title;

  const SurveySectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTypography.headline6.copyWith(color: AppColors.grayScale_650),
    );
  }
}

class TravelPeriodPage extends ConsumerWidget {
  final PageController pageController;

  const TravelPeriodPage({super.key, required this.pageController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(surveyProvider);
    final notifier = ref.read(surveyProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '여행 기간은\n어떻게 되시나요?',
          style: AppTypography.headline2,
        ),
        const SizedBox(height: 30),
        SurveySectionTitle(title: '여행 시기'),
        SurveyChipList(
          items: ['일주일 이내', '1달 내', '3개월', '일정 계획 없음'],
          selectedItem: state.travelPeriod ?? '',
          onSelected: (selected) {
            notifier.selectTravelPeriod(selected);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final updatedState = ref.read(surveyProvider);
              if (updatedState.isCurrentPageComplete()) {
                ref.read(surveyProvider.notifier).nextPage();
                pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            });
          },
        ),
        const SizedBox(height: 30),
        SurveySectionTitle(title: '여행 기간'),
        SurveyChipList(
          items: ['당일치기', '1박 2일', '2박 3일', '3박 4일', '4박 5일', '5박 6일'],
          selectedItem: state.travelDuration ?? '',
          onSelected: (selected) {
            notifier.selectTravelDuration(selected);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final updatedState = ref.read(surveyProvider);
              if (updatedState.isCurrentPageComplete()) {
                ref.read(surveyProvider.notifier).nextPage();
                pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            });
          },
        ),
      ],
    );
  }
}

class TravelStylePage extends ConsumerWidget {
  final PageController pageController;

  const TravelStylePage({super.key, required this.pageController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(surveyProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '어떤 스타일의\n여행을 할 계획인가요?',
          style: AppTypography.headline2,
        ),
        const SizedBox(height: 30),
        SurveySectionTitle(title: '누구와'),
        SurveyChipList(
          items: ['혼자', '연인과', '친구와', '가족과'],
          selectedItem: state.companion ?? '',
          onSelected: (value) {
            ref.read(surveyProvider.notifier).selectCompanion(value);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final updatedState = ref.read(surveyProvider);
              if (updatedState.isCurrentPageComplete()) {
                ref.read(surveyProvider.notifier).nextPage();
                pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            });
          },
        ),
        const SizedBox(height: 30),
        SurveySectionTitle(title: '여행 스타일'),
        SurveyChipList(
          items: ['액티비티', '휴양', '관광지', '맛집', '문화/예술/역사', '쇼핑'],
          selectedItem: state.travelStyle ?? '',
          onSelected: (value) {
            ref.read(surveyProvider.notifier).selectTravelStyle(value);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final updatedState = ref.read(surveyProvider);
              if (updatedState.isCurrentPageComplete()) {
                ref.read(surveyProvider.notifier).nextPage();
                pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            });
          },
        ),
      ],
    );
  }
}

class AccommodationPage extends ConsumerWidget {
  final PageController pageController;

  const AccommodationPage({super.key, required this.pageController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(surveyProvider);
    final surveyNotifier = ref.read(surveyProvider.notifier);

    final accommodationTypes = ['호텔', '게스트 하우스', '에어비앤비', '캠핑'];
    final considerations = ['가성비', '시설', '위치', '청결', '기온', '시차', '없음'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '숙소 스타일과\n고려해야할 사항을 알려주세요',
          style: AppTypography.headline2,
        ),
        const SizedBox(height: 30),
        SurveySectionTitle(title: '숙소 스타일'),
        SurveyChipList(
          items: accommodationTypes,
          selectedItem: state.accommodationType ?? '',
          onSelected: (type) {
            surveyNotifier.selectAccommodationType(type);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final updatedState = ref.read(surveyProvider);
              if (updatedState.isCurrentPageComplete()) {
                final surveyResponse = updatedState.toSurveyResponse();
                Navigator.pushNamed(
                  context,
                  '/plan-selection',
                  arguments: surveyResponse,
                );
              }
            });
          },
        ),
        const SizedBox(height: 30),
        SurveySectionTitle(title: '고려사항'),
        SurveyChipList(
          items: considerations,
          selectedItem: state.consideration ?? '',
          onSelected: (consideration) {
            surveyNotifier.selectConsideration(consideration);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final updatedState = ref.read(surveyProvider);
              if (updatedState.isCurrentPageComplete()) {
                final surveyResponse = updatedState.toSurveyResponse();
                Navigator.pushNamed(
                  context,
                  '/plan-selection',
                  arguments: surveyResponse,
                );
              }
            });
          },
        ),
      ],
    );
  }
}
