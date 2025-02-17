import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/domain/entity/survey_response.dart';
import 'package:wetravel/presentation/provider/recommendation_provider.dart';
import 'package:wetravel/presentation/provider/survey/survey_provider.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(surveyStateProvider.notifier).resetState();
    });
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
                value: 1 / 2,
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
    final state = ref.read(surveyStateProvider);
    print('Travel Period Page - Selected values:');
    print('Travel Period: ${state.travelPeriod}');
    print('Travel Duration: ${state.travelDuration}');

    // 여행 시기와 기간이 모두 선택되었을 때만 다음 페이지로 이동
    if (state.travelPeriod != null && state.travelDuration != null) {
      // 여행 시기와 기간이 서로 다른 카테고리에서 선택되었는지 확인
      if (state.travelPeriod != state.travelDuration) {
        // 서로 다른 값이 선택되었는지 확인
        ref.read(surveyStateProvider.notifier).nextPage();
        pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(surveyStateProvider);

    return Column(
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
          spacing: 8,
          runSpacing: 8,
          children: [
            FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.travelPeriod == '일주일 이내') ...[
                    const Icon(Icons.check, size: 16, color: Colors.white),
                    const SizedBox(width: 4),
                  ],
                  const Text('일주일 이내'),
                ],
              ),
              selected: state.travelPeriod == '일주일 이내',
              onSelected: (selected) {
                if (selected) {
                  final notifier = ref.read(surveyStateProvider.notifier);
                  notifier.selectTravelPeriod('일주일 이내');
                  print('Selected travel period: 일주일 이내');
                  _checkAndNavigate(context, ref);
                }
              },
              showCheckmark: false,
              side: const BorderSide(style: BorderStyle.none),
              shape:
                  RoundedRectangleBorder(borderRadius: AppBorderRadius.large20),
              backgroundColor: AppColors.grayScale_050,
              selectedColor: AppColors.grayScale_650,
              labelStyle: TextStyle(
                color: state.travelPeriod == '일주일 이내'
                    ? Colors.white
                    : AppColors.grayScale_350,
              ),
            ),
            FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.travelPeriod == '1달 내') ...[
                    const Icon(Icons.check, size: 16, color: Colors.white),
                    const SizedBox(width: 4),
                  ],
                  const Text('1달 내'),
                ],
              ),
              selected: state.travelPeriod == '1달 내',
              onSelected: (selected) {
                if (selected) {
                  final notifier = ref.read(surveyStateProvider.notifier);
                  notifier.selectTravelPeriod('1달 내');
                  print('Selected travel period: 1달 내');
                  _checkAndNavigate(context, ref);
                }
              },
              showCheckmark: false,
              side: const BorderSide(style: BorderStyle.none),
              shape:
                  RoundedRectangleBorder(borderRadius: AppBorderRadius.large20),
              backgroundColor: AppColors.grayScale_050,
              selectedColor: AppColors.grayScale_650,
              labelStyle: TextStyle(
                color: state.travelPeriod == '1달 내'
                    ? Colors.white
                    : AppColors.grayScale_350,
              ),
            ),
            FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.travelPeriod == '3개월') ...[
                    const Icon(Icons.check, size: 16, color: Colors.white),
                    const SizedBox(width: 4),
                  ],
                  const Text('3개월'),
                ],
              ),
              selected: state.travelPeriod == '3개월',
              onSelected: (selected) {
                if (selected) {
                  final notifier = ref.read(surveyStateProvider.notifier);
                  notifier.selectTravelPeriod('3개월');
                  print('Selected travel period: 3개월');
                  _checkAndNavigate(context, ref);
                }
              },
              showCheckmark: false,
              side: const BorderSide(style: BorderStyle.none),
              shape:
                  RoundedRectangleBorder(borderRadius: AppBorderRadius.large20),
              backgroundColor: AppColors.grayScale_050,
              selectedColor: AppColors.grayScale_650,
              labelStyle: TextStyle(
                color: state.travelPeriod == '3개월'
                    ? Colors.white
                    : AppColors.grayScale_350,
              ),
            ),
            FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.travelPeriod == '일정 계획 없음') ...[
                    const Icon(Icons.check, size: 16, color: Colors.white),
                    const SizedBox(width: 4),
                  ],
                  const Text('일정 계획 없음'),
                ],
              ),
              selected: state.travelPeriod == '일정 계획 없음',
              onSelected: (selected) {
                if (selected) {
                  final notifier = ref.read(surveyStateProvider.notifier);
                  notifier.selectTravelPeriod('일정 계획 없음');
                  print('Selected travel period: 일정 계획 없음');
                  _checkAndNavigate(context, ref);
                }
              },
              showCheckmark: false,
              side: const BorderSide(style: BorderStyle.none),
              shape:
                  RoundedRectangleBorder(borderRadius: AppBorderRadius.large20),
              backgroundColor: AppColors.grayScale_050,
              selectedColor: AppColors.grayScale_650,
              labelStyle: TextStyle(
                color: state.travelPeriod == '일정 계획 없음'
                    ? Colors.white
                    : AppColors.grayScale_350,
              ),
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
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.travelDuration == '당일치기') ...[
                    const Icon(Icons.check, size: 16, color: Colors.white),
                    const SizedBox(width: 4),
                  ],
                  Text('당일치기'),
                ],
              ),
              selected: state.travelDuration == '당일치기',
              onSelected: (selected) {
                if (selected) {
                  ref
                      .read(surveyStateProvider.notifier)
                      .selectTravelDuration('당일치기');
                  _checkAndNavigate(context, ref);
                }
              },
              showCheckmark: false,
              side: const BorderSide(style: BorderStyle.none),
              shape:
                  RoundedRectangleBorder(borderRadius: AppBorderRadius.large20),
              backgroundColor: AppColors.grayScale_050,
              selectedColor: AppColors.grayScale_650,
              labelStyle: TextStyle(
                color: state.travelDuration == '당일치기'
                    ? Colors.white
                    : AppColors.grayScale_350,
              ),
            ),
            FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.travelDuration == '1박 2일') ...[
                    const Icon(Icons.check, size: 16, color: Colors.white),
                    const SizedBox(width: 4),
                  ],
                  Text('1박 2일'),
                ],
              ),
              selected: state.travelDuration == '1박 2일',
              onSelected: (selected) {
                if (selected) {
                  ref
                      .read(surveyStateProvider.notifier)
                      .selectTravelDuration('1박 2일');
                  _checkAndNavigate(context, ref);
                }
              },
              showCheckmark: false,
              side: const BorderSide(style: BorderStyle.none),
              shape:
                  RoundedRectangleBorder(borderRadius: AppBorderRadius.large20),
              backgroundColor: AppColors.grayScale_050,
              selectedColor: AppColors.grayScale_650,
              labelStyle: TextStyle(
                color: state.travelDuration == '1박 2일'
                    ? Colors.white
                    : AppColors.grayScale_350,
              ),
            ),
            FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.travelDuration == '2박 3일') ...[
                    const Icon(Icons.check, size: 16, color: Colors.white),
                    const SizedBox(width: 4),
                  ],
                  Text('2박 3일'),
                ],
              ),
              selected: state.travelDuration == '2박 3일',
              onSelected: (selected) {
                if (selected) {
                  ref
                      .read(surveyStateProvider.notifier)
                      .selectTravelDuration('2박 3일');
                  _checkAndNavigate(context, ref);
                }
              },
              showCheckmark: false,
              side: const BorderSide(style: BorderStyle.none),
              shape:
                  RoundedRectangleBorder(borderRadius: AppBorderRadius.large20),
              backgroundColor: AppColors.grayScale_050,
              selectedColor: AppColors.grayScale_650,
              labelStyle: TextStyle(
                color: state.travelDuration == '2박 3일'
                    ? Colors.white
                    : AppColors.grayScale_350,
              ),
            ),
            FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.travelDuration == '3박 4일') ...[
                    const Icon(Icons.check, size: 16, color: Colors.white),
                    const SizedBox(width: 4),
                  ],
                  Text('3박 4일'),
                ],
              ),
              selected: state.travelDuration == '3박 4일',
              onSelected: (selected) {
                if (selected) {
                  ref
                      .read(surveyStateProvider.notifier)
                      .selectTravelDuration('3박 4일');
                  _checkAndNavigate(context, ref);
                }
              },
              showCheckmark: false,
              side: const BorderSide(style: BorderStyle.none),
              shape:
                  RoundedRectangleBorder(borderRadius: AppBorderRadius.large20),
              backgroundColor: AppColors.grayScale_050,
              selectedColor: AppColors.grayScale_650,
              labelStyle: TextStyle(
                color: state.travelDuration == '3박 4일'
                    ? Colors.white
                    : AppColors.grayScale_350,
              ),
            ),
            FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.travelDuration == '4박 5일') ...[
                    const Icon(Icons.check, size: 16, color: Colors.white),
                    const SizedBox(width: 4),
                  ],
                  Text('4박 5일'),
                ],
              ),
              selected: state.travelDuration == '4박 5일',
              onSelected: (selected) {
                if (selected) {
                  ref
                      .read(surveyStateProvider.notifier)
                      .selectTravelDuration('4박 5일');
                  _checkAndNavigate(context, ref);
                }
              },
              showCheckmark: false,
              side: const BorderSide(style: BorderStyle.none),
              shape:
                  RoundedRectangleBorder(borderRadius: AppBorderRadius.large20),
              backgroundColor: AppColors.grayScale_050,
              selectedColor: AppColors.grayScale_650,
              labelStyle: TextStyle(
                color: state.travelDuration == '4박 5일'
                    ? Colors.white
                    : AppColors.grayScale_350,
              ),
            ),
            FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.travelDuration == '5박 6일') ...[
                    const Icon(Icons.check, size: 16, color: Colors.white),
                    const SizedBox(width: 4),
                  ],
                  Text('5박 6일'),
                ],
              ),
              selected: state.travelDuration == '5박 6일',
              onSelected: (selected) {
                if (selected) {
                  ref
                      .read(surveyStateProvider.notifier)
                      .selectTravelDuration('5박 6일');
                  _checkAndNavigate(context, ref);
                }
              },
              showCheckmark: false,
              side: const BorderSide(style: BorderStyle.none),
              shape:
                  RoundedRectangleBorder(borderRadius: AppBorderRadius.large20),
              backgroundColor: AppColors.grayScale_050,
              selectedColor: AppColors.grayScale_650,
              labelStyle: TextStyle(
                color: state.travelDuration == '5박 6일'
                    ? Colors.white
                    : AppColors.grayScale_350,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// 여행 스타일 페이지
class TravelStylePage extends ConsumerWidget {
  final PageController pageController;

  const TravelStylePage({super.key, required this.pageController});

  void _checkAndNavigate(BuildContext context, WidgetRef ref) {
    if (ref.read(surveyStateProvider.notifier).isCurrentPageComplete()) {
      final state = ref.read(surveyStateProvider);
      print('Travel Style Page - Selected values:');
      print('Companion: ${state.companion}');
      print('Travel Style: ${state.travelStyle}');

      ref.read(surveyStateProvider.notifier).nextPage();
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(surveyStateProvider);

    return Column(
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
          spacing: 8,
          runSpacing: 8,
          children: [
            FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.companion == '혼자') ...[
                    const Icon(Icons.check, size: 16, color: Colors.white),
                    const SizedBox(width: 4),
                  ],
                  const Text('혼자'),
                ],
              ),
              selected: state.companion == '혼자',
              onSelected: (selected) {
                if (selected) {
                  ref.read(surveyStateProvider.notifier).selectCompanion('혼자');
                  _checkAndNavigate(context, ref);
                }
              },
              showCheckmark: false,
              side: const BorderSide(style: BorderStyle.none),
              shape:
                  RoundedRectangleBorder(borderRadius: AppBorderRadius.large20),
              backgroundColor: AppColors.grayScale_050,
              selectedColor: AppColors.grayScale_650,
              labelStyle: TextStyle(
                color: state.companion == '혼자'
                    ? Colors.white
                    : AppColors.grayScale_350,
              ),
            ),
            FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.companion == '연인과') ...[
                    const Icon(Icons.check, size: 16, color: Colors.white),
                    const SizedBox(width: 4),
                  ],
                  const Text('연인과'),
                ],
              ),
              selected: state.companion == '연인과',
              onSelected: (selected) {
                if (selected) {
                  ref.read(surveyStateProvider.notifier).selectCompanion('연인과');
                  _checkAndNavigate(context, ref);
                }
              },
              showCheckmark: false,
              side: const BorderSide(style: BorderStyle.none),
              shape:
                  RoundedRectangleBorder(borderRadius: AppBorderRadius.large20),
              backgroundColor: AppColors.grayScale_050,
              selectedColor: AppColors.grayScale_650,
              labelStyle: TextStyle(
                color: state.companion == '연인과'
                    ? Colors.white
                    : AppColors.grayScale_350,
              ),
            ),
            FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.companion == '친구와') ...[
                    const Icon(Icons.check, size: 16, color: Colors.white),
                    const SizedBox(width: 4),
                  ],
                  const Text('친구와'),
                ],
              ),
              selected: state.companion == '친구와',
              onSelected: (selected) {
                if (selected) {
                  ref.read(surveyStateProvider.notifier).selectCompanion('친구와');
                  _checkAndNavigate(context, ref);
                }
              },
              showCheckmark: false,
              side: const BorderSide(style: BorderStyle.none),
              shape:
                  RoundedRectangleBorder(borderRadius: AppBorderRadius.large20),
              backgroundColor: AppColors.grayScale_050,
              selectedColor: AppColors.grayScale_650,
              labelStyle: TextStyle(
                color: state.companion == '친구와'
                    ? Colors.white
                    : AppColors.grayScale_350,
              ),
            ),
            FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.companion == '가족과') ...[
                    const Icon(Icons.check, size: 16, color: Colors.white),
                    const SizedBox(width: 4),
                  ],
                  const Text('가족과'),
                ],
              ),
              selected: state.companion == '가족과',
              onSelected: (selected) {
                if (selected) {
                  ref.read(surveyStateProvider.notifier).selectCompanion('가족과');
                  _checkAndNavigate(context, ref);
                }
              },
              showCheckmark: false,
              side: const BorderSide(style: BorderStyle.none),
              shape:
                  RoundedRectangleBorder(borderRadius: AppBorderRadius.large20),
              backgroundColor: AppColors.grayScale_050,
              selectedColor: AppColors.grayScale_650,
              labelStyle: TextStyle(
                color: state.companion == '가족과'
                    ? Colors.white
                    : AppColors.grayScale_350,
              ),
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
          spacing: 8,
          runSpacing: 8,
          children: [
            FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.travelStyle == '액티비티') ...[
                    const Icon(Icons.check, size: 16, color: Colors.white),
                    const SizedBox(width: 4),
                  ],
                  const Text('액티비티'),
                ],
              ),
              selected: state.travelStyle == '액티비티',
              onSelected: (selected) {
                if (selected) {
                  ref
                      .read(surveyStateProvider.notifier)
                      .selectTravelStyle('액티비티');
                  _checkAndNavigate(context, ref);
                }
              },
              showCheckmark: false,
              side: const BorderSide(style: BorderStyle.none),
              shape:
                  RoundedRectangleBorder(borderRadius: AppBorderRadius.large20),
              backgroundColor: AppColors.grayScale_050,
              selectedColor: AppColors.grayScale_650,
              labelStyle: TextStyle(
                color: state.travelStyle == '액티비티'
                    ? Colors.white
                    : AppColors.grayScale_350,
              ),
            ),
            FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.travelStyle == '휴양') ...[
                    const Icon(Icons.check, size: 16, color: Colors.white),
                    const SizedBox(width: 4),
                  ],
                  const Text('휴양'),
                ],
              ),
              selected: state.travelStyle == '휴양',
              onSelected: (selected) {
                if (selected) {
                  ref
                      .read(surveyStateProvider.notifier)
                      .selectTravelStyle('휴양');
                  _checkAndNavigate(context, ref);
                }
              },
              showCheckmark: false,
              side: const BorderSide(style: BorderStyle.none),
              shape:
                  RoundedRectangleBorder(borderRadius: AppBorderRadius.large20),
              backgroundColor: AppColors.grayScale_050,
              selectedColor: AppColors.grayScale_650,
              labelStyle: TextStyle(
                color: state.travelStyle == '휴양'
                    ? Colors.white
                    : AppColors.grayScale_350,
              ),
            ),
            FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.travelStyle == '관광지') ...[
                    const Icon(Icons.check, size: 16, color: Colors.white),
                    const SizedBox(width: 4),
                  ],
                  const Text('관광지'),
                ],
              ),
              selected: state.travelStyle == '관광지',
              onSelected: (selected) {
                if (selected) {
                  ref
                      .read(surveyStateProvider.notifier)
                      .selectTravelStyle('관광지');
                  _checkAndNavigate(context, ref);
                }
              },
              showCheckmark: false,
              side: const BorderSide(style: BorderStyle.none),
              shape:
                  RoundedRectangleBorder(borderRadius: AppBorderRadius.large20),
              backgroundColor: AppColors.grayScale_050,
              selectedColor: AppColors.grayScale_650,
              labelStyle: TextStyle(
                color: state.travelStyle == '관광지'
                    ? Colors.white
                    : AppColors.grayScale_350,
              ),
            ),
            FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.travelStyle == '맛집') ...[
                    const Icon(Icons.check, size: 16, color: Colors.white),
                    const SizedBox(width: 4),
                  ],
                  const Text('맛집'),
                ],
              ),
              selected: state.travelStyle == '맛집',
              onSelected: (selected) {
                if (selected) {
                  ref
                      .read(surveyStateProvider.notifier)
                      .selectTravelStyle('맛집');
                  _checkAndNavigate(context, ref);
                }
              },
              showCheckmark: false,
              side: const BorderSide(style: BorderStyle.none),
              shape:
                  RoundedRectangleBorder(borderRadius: AppBorderRadius.large20),
              backgroundColor: AppColors.grayScale_050,
              selectedColor: AppColors.grayScale_650,
              labelStyle: TextStyle(
                color: state.travelStyle == '맛집'
                    ? Colors.white
                    : AppColors.grayScale_350,
              ),
            ),
            FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.travelStyle == '문화/예술/역사') ...[
                    const Icon(Icons.check, size: 16, color: Colors.white),
                    const SizedBox(width: 4),
                  ],
                  const Text('문화/예술/역사'),
                ],
              ),
              selected: state.travelStyle == '문화/예술/역사',
              onSelected: (selected) {
                if (selected) {
                  ref
                      .read(surveyStateProvider.notifier)
                      .selectTravelStyle('문화/예술/역사');
                  _checkAndNavigate(context, ref);
                }
              },
              showCheckmark: false,
              side: const BorderSide(style: BorderStyle.none),
              shape:
                  RoundedRectangleBorder(borderRadius: AppBorderRadius.large20),
              backgroundColor: AppColors.grayScale_050,
              selectedColor: AppColors.grayScale_650,
              labelStyle: TextStyle(
                color: state.travelStyle == '문화/예술/역사'
                    ? Colors.white
                    : AppColors.grayScale_350,
              ),
            ),
            FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.travelStyle == '쇼핑') ...[
                    const Icon(Icons.check, size: 16, color: Colors.white),
                    const SizedBox(width: 4),
                  ],
                  const Text('쇼핑'),
                ],
              ),
              selected: state.travelStyle == '쇼핑',
              onSelected: (selected) {
                if (selected) {
                  ref
                      .read(surveyStateProvider.notifier)
                      .selectTravelStyle('쇼핑');
                  _checkAndNavigate(context, ref);
                }
              },
              showCheckmark: false,
              side: const BorderSide(style: BorderStyle.none),
              shape:
                  RoundedRectangleBorder(borderRadius: AppBorderRadius.large20),
              backgroundColor: AppColors.grayScale_050,
              selectedColor: AppColors.grayScale_650,
              labelStyle: TextStyle(
                color: state.travelStyle == '쇼핑'
                    ? Colors.white
                    : AppColors.grayScale_350,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// 숙소 스타일 페이지
class AccommodationPage extends ConsumerWidget {
  final PageController pageController;

  const AccommodationPage({super.key, required this.pageController});

  void _checkAndNavigate(BuildContext context, WidgetRef ref) {
    if (ref.read(surveyStateProvider.notifier).isCurrentPageComplete()) {
      final state = ref.read(surveyStateProvider);
      print('Creating SurveyResponse from AccommodationPage:');
      print('Travel Period: ${state.travelPeriod}');
      print('Travel Duration: ${state.travelDuration}');
      print('Companion: ${state.companion}');
      print('Travel Style: ${state.travelStyle}');
      print('Accommodation Type: ${state.accommodationType}');
      print('Consideration: ${state.consideration}');
      print('Selected City: ${state.selectedCities}');

      // 마지막 페이지에서만 SurveyResponse 생성 및 네비게이션
      if (state.currentPage == 2) {
        final surveyResponse = SurveyResponse(
          travelPeriod: state.travelPeriod ?? '',
          travelDuration: state.travelDuration ?? '',
          companions: state.companion != null ? [state.companion!] : [],
          travelStyles: state.travelStyle != null ? [state.travelStyle!] : [],
          accommodationTypes:
              state.accommodationType != null ? [state.accommodationType!] : [],
          considerations:
              state.consideration != null ? [state.consideration!] : [],
          selectedCity:
              ref.watch(recommendationStateProvider).selectedCities[0],
        );

        Navigator.pushNamed(
          context,
          '/plan-selection',
          arguments: surveyResponse,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(surveyStateProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '숙소 스타일과\n고려해야할 사항을 알려주세요',
          style: AppTypography.headline2,
        ),
        const SizedBox(height: 30),
        Text(
          '숙소 스타일',
          style: AppTypography.headline6.copyWith(
            color: AppColors.grayScale_650,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.accommodationType == '호텔') ...[
                    const Icon(Icons.check, size: 16, color: Colors.white),
                    const SizedBox(width: 4),
                  ],
                  const Text('호텔'),
                ],
              ),
              selected: state.accommodationType == '호텔',
              onSelected: (selected) {
                if (selected) {
                  ref
                      .read(surveyStateProvider.notifier)
                      .selectAccommodationType('호텔');
                  _checkAndNavigate(context, ref);
                }
              },
              showCheckmark: false,
              side: const BorderSide(style: BorderStyle.none),
              shape:
                  RoundedRectangleBorder(borderRadius: AppBorderRadius.large20),
              backgroundColor: AppColors.grayScale_050,
              selectedColor: AppColors.grayScale_650,
              labelStyle: TextStyle(
                color: state.accommodationType == '호텔'
                    ? Colors.white
                    : AppColors.grayScale_350,
              ),
            ),
            FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.accommodationType == '게스트 하우스') ...[
                    const Icon(Icons.check, size: 16, color: Colors.white),
                    const SizedBox(width: 4),
                  ],
                  const Text('게스트 하우스'),
                ],
              ),
              selected: state.accommodationType == '게스트 하우스',
              onSelected: (selected) {
                if (selected) {
                  ref
                      .read(surveyStateProvider.notifier)
                      .selectAccommodationType('게스트 하우스');
                  _checkAndNavigate(context, ref);
                }
              },
              showCheckmark: false,
              side: const BorderSide(style: BorderStyle.none),
              shape:
                  RoundedRectangleBorder(borderRadius: AppBorderRadius.large20),
              backgroundColor: AppColors.grayScale_050,
              selectedColor: AppColors.grayScale_650,
              labelStyle: TextStyle(
                color: state.accommodationType == '게스트 하우스'
                    ? Colors.white
                    : AppColors.grayScale_350,
              ),
            ),
            FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.accommodationType == '에어비앤비') ...[
                    const Icon(Icons.check, size: 16, color: Colors.white),
                    const SizedBox(width: 4),
                  ],
                  const Text('에어비앤비'),
                ],
              ),
              selected: state.accommodationType == '에어비앤비',
              onSelected: (selected) {
                if (selected) {
                  ref
                      .read(surveyStateProvider.notifier)
                      .selectAccommodationType('에어비앤비');
                  _checkAndNavigate(context, ref);
                }
              },
              showCheckmark: false,
              side: const BorderSide(style: BorderStyle.none),
              shape:
                  RoundedRectangleBorder(borderRadius: AppBorderRadius.large20),
              backgroundColor: AppColors.grayScale_050,
              selectedColor: AppColors.grayScale_650,
              labelStyle: TextStyle(
                color: state.accommodationType == '에어비앤비'
                    ? Colors.white
                    : AppColors.grayScale_350,
              ),
            ),
            FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.accommodationType == '캠핑') ...[
                    const Icon(Icons.check, size: 16, color: Colors.white),
                    const SizedBox(width: 4),
                  ],
                  const Text('캠핑'),
                ],
              ),
              selected: state.accommodationType == '캠핑',
              onSelected: (selected) {
                if (selected) {
                  ref
                      .read(surveyStateProvider.notifier)
                      .selectAccommodationType('캠핑');
                  _checkAndNavigate(context, ref);
                }
              },
              showCheckmark: false,
              side: const BorderSide(style: BorderStyle.none),
              shape:
                  RoundedRectangleBorder(borderRadius: AppBorderRadius.large20),
              backgroundColor: AppColors.grayScale_050,
              selectedColor: AppColors.grayScale_650,
              labelStyle: TextStyle(
                color: state.accommodationType == '캠핑'
                    ? Colors.white
                    : AppColors.grayScale_350,
              ),
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
          spacing: 8,
          runSpacing: 8,
          children: [
            FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.consideration == '가성비') ...[
                    const Icon(Icons.check, size: 16, color: Colors.white),
                    const SizedBox(width: 4),
                  ],
                  const Text('가성비'),
                ],
              ),
              selected: state.consideration == '가성비',
              onSelected: (selected) {
                if (selected) {
                  ref
                      .read(surveyStateProvider.notifier)
                      .selectConsideration('가성비');
                  _checkAndNavigate(context, ref);
                }
              },
              showCheckmark: false,
              side: const BorderSide(style: BorderStyle.none),
              shape:
                  RoundedRectangleBorder(borderRadius: AppBorderRadius.large20),
              backgroundColor: AppColors.grayScale_050,
              selectedColor: AppColors.grayScale_650,
              labelStyle: TextStyle(
                color: state.consideration == '가성비'
                    ? Colors.white
                    : AppColors.grayScale_350,
              ),
            ),
            FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.consideration == '시설') ...[
                    const Icon(Icons.check, size: 16, color: Colors.white),
                    const SizedBox(width: 4),
                  ],
                  const Text('시설'),
                ],
              ),
              selected: state.consideration == '시설',
              onSelected: (selected) {
                if (selected) {
                  ref
                      .read(surveyStateProvider.notifier)
                      .selectConsideration('시설');
                  _checkAndNavigate(context, ref);
                }
              },
              showCheckmark: false,
              side: const BorderSide(style: BorderStyle.none),
              shape:
                  RoundedRectangleBorder(borderRadius: AppBorderRadius.large20),
              backgroundColor: AppColors.grayScale_050,
              selectedColor: AppColors.grayScale_650,
              labelStyle: TextStyle(
                color: state.consideration == '시설'
                    ? Colors.white
                    : AppColors.grayScale_350,
              ),
            ),
            FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.consideration == '위치') ...[
                    const Icon(Icons.check, size: 16, color: Colors.white),
                    const SizedBox(width: 4),
                  ],
                  const Text('위치'),
                ],
              ),
              selected: state.consideration == '위치',
              onSelected: (selected) {
                if (selected) {
                  ref
                      .read(surveyStateProvider.notifier)
                      .selectConsideration('위치');
                  _checkAndNavigate(context, ref);
                }
              },
              showCheckmark: false,
              side: const BorderSide(style: BorderStyle.none),
              shape:
                  RoundedRectangleBorder(borderRadius: AppBorderRadius.large20),
              backgroundColor: AppColors.grayScale_050,
              selectedColor: AppColors.grayScale_650,
              labelStyle: TextStyle(
                color: state.consideration == '위치'
                    ? Colors.white
                    : AppColors.grayScale_350,
              ),
            ),
            FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.consideration == '청결') ...[
                    const Icon(Icons.check, size: 16, color: Colors.white),
                    const SizedBox(width: 4),
                  ],
                  const Text('청결'),
                ],
              ),
              selected: state.consideration == '청결',
              onSelected: (selected) {
                if (selected) {
                  ref
                      .read(surveyStateProvider.notifier)
                      .selectConsideration('청결');
                  _checkAndNavigate(context, ref);
                }
              },
              showCheckmark: false,
              side: const BorderSide(style: BorderStyle.none),
              shape:
                  RoundedRectangleBorder(borderRadius: AppBorderRadius.large20),
              backgroundColor: AppColors.grayScale_050,
              selectedColor: AppColors.grayScale_650,
              labelStyle: TextStyle(
                color: state.consideration == '청결'
                    ? Colors.white
                    : AppColors.grayScale_350,
              ),
            ),
            FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.consideration == '기온') ...[
                    const Icon(Icons.check, size: 16, color: Colors.white),
                    const SizedBox(width: 4),
                  ],
                  const Text('기온'),
                ],
              ),
              selected: state.consideration == '기온',
              onSelected: (selected) {
                if (selected) {
                  ref
                      .read(surveyStateProvider.notifier)
                      .selectConsideration('기온');
                  _checkAndNavigate(context, ref);
                }
              },
              showCheckmark: false,
              side: const BorderSide(style: BorderStyle.none),
              shape:
                  RoundedRectangleBorder(borderRadius: AppBorderRadius.large20),
              backgroundColor: AppColors.grayScale_050,
              selectedColor: AppColors.grayScale_650,
              labelStyle: TextStyle(
                color: state.consideration == '기온'
                    ? Colors.white
                    : AppColors.grayScale_350,
              ),
            ),
            FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.consideration == '시차') ...[
                    const Icon(Icons.check, size: 16, color: Colors.white),
                    const SizedBox(width: 4),
                  ],
                  const Text('시차'),
                ],
              ),
              selected: state.consideration == '시차',
              onSelected: (selected) {
                if (selected) {
                  ref
                      .read(surveyStateProvider.notifier)
                      .selectConsideration('시차');
                  _checkAndNavigate(context, ref);
                }
              },
              showCheckmark: false,
              side: const BorderSide(style: BorderStyle.none),
              shape:
                  RoundedRectangleBorder(borderRadius: AppBorderRadius.large20),
              backgroundColor: AppColors.grayScale_050,
              selectedColor: AppColors.grayScale_650,
              labelStyle: TextStyle(
                color: state.consideration == '시차'
                    ? Colors.white
                    : AppColors.grayScale_350,
              ),
            ),
            FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.consideration == '없음') ...[
                    const Icon(Icons.check, size: 16, color: Colors.white),
                    const SizedBox(width: 4),
                  ],
                  const Text('없음'),
                ],
              ),
              selected: state.consideration == '없음',
              onSelected: (selected) {
                if (selected) {
                  ref
                      .read(surveyStateProvider.notifier)
                      .selectConsideration('없음');
                  _checkAndNavigate(context, ref);
                }
              },
              showCheckmark: false,
              side: const BorderSide(style: BorderStyle.none),
              shape:
                  RoundedRectangleBorder(borderRadius: AppBorderRadius.large20),
              backgroundColor: AppColors.grayScale_050,
              selectedColor: AppColors.grayScale_650,
              labelStyle: TextStyle(
                color: state.consideration == '없음'
                    ? Colors.white
                    : AppColors.grayScale_350,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
