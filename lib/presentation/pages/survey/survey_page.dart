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
      ref.read(surveyProvider.notifier).resetState();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(surveyProvider);

    // 현재 페이지에 따른 진행률 계산
    double progressValue =
        0.4 + (state.currentPage * 0.2); // 40% 시작, 각 단계마다 20% 증가

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
                  onPressed: () => _onNextPressed(state),
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
      print(
          'Completing survey with selected city: ${surveyResponse.selectedCity}'); // 디버깅용

      Navigator.pushNamed(
        context,
        '/plan-selection',
        arguments: surveyResponse,
      );
    }
  }
}

// 여행 기간 페이지
class TravelPeriodPage extends ConsumerWidget {
  final PageController pageController;

  const TravelPeriodPage({super.key, required this.pageController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(surveyProvider);

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
                  final notifier = ref.read(surveyProvider.notifier);
                  notifier.selectTravelPeriod('일주일 이내');
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
                  final notifier = ref.read(surveyProvider.notifier);
                  notifier.selectTravelPeriod('1달 내');
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
                  final notifier = ref.read(surveyProvider.notifier);
                  notifier.selectTravelPeriod('3개월');
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
                  final notifier = ref.read(surveyProvider.notifier);
                  notifier.selectTravelPeriod('일정 계획 없음');
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
                      .read(surveyProvider.notifier)
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
                      .read(surveyProvider.notifier)
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
                      .read(surveyProvider.notifier)
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
                      .read(surveyProvider.notifier)
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
                      .read(surveyProvider.notifier)
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
                      .read(surveyProvider.notifier)
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

  void _checkAndNavigate(BuildContext context, WidgetRef ref) {
    final state = ref.read(surveyProvider);
    if (state.isCurrentPageComplete()) {
      ref.read(surveyProvider.notifier).nextPage();
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}

// 여행 스타일 페이지
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
                  ref.read(surveyProvider.notifier).selectCompanion('혼자');
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
                  ref.read(surveyProvider.notifier).selectCompanion('연인과');
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
                  ref.read(surveyProvider.notifier).selectCompanion('친구와');
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
                  ref.read(surveyProvider.notifier).selectCompanion('가족과');
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
                  ref.read(surveyProvider.notifier).selectTravelStyle('액티비티');
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
                  ref.read(surveyProvider.notifier).selectTravelStyle('휴양');
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
                  ref.read(surveyProvider.notifier).selectTravelStyle('관광지');
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
                  ref.read(surveyProvider.notifier).selectTravelStyle('맛집');
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
                      .read(surveyProvider.notifier)
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
                  ref.read(surveyProvider.notifier).selectTravelStyle('쇼핑');
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

  void _checkAndNavigate(BuildContext context, WidgetRef ref) {
    final state = ref.read(surveyProvider);
    if (state.isCurrentPageComplete()) {
      ref.read(surveyProvider.notifier).nextPage();
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}

// 숙소 스타일 페이지
class AccommodationPage extends ConsumerWidget {
  final PageController pageController;

  const AccommodationPage({super.key, required this.pageController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(surveyProvider);

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
                      .read(surveyProvider.notifier)
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
                      .read(surveyProvider.notifier)
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
                      .read(surveyProvider.notifier)
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
                      .read(surveyProvider.notifier)
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
                  ref.read(surveyProvider.notifier).selectConsideration('가성비');
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
                  ref.read(surveyProvider.notifier).selectConsideration('시설');
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
                  ref.read(surveyProvider.notifier).selectConsideration('위치');
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
                  ref.read(surveyProvider.notifier).selectConsideration('청결');
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
                  ref.read(surveyProvider.notifier).selectConsideration('기온');
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
                  ref.read(surveyProvider.notifier).selectConsideration('시차');
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
                  ref.read(surveyProvider.notifier).selectConsideration('없음');
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

  void _checkAndNavigate(BuildContext context, WidgetRef ref) {
    final state = ref.read(surveyProvider);
    if (state.isCurrentPageComplete()) {
      if (state.currentPage == 2) {
        final surveyResponse = state.toSurveyResponse();
        Navigator.pushNamed(
          context,
          '/plan-selection',
          arguments: surveyResponse,
        );
      } else {
        ref.read(surveyProvider.notifier).nextPage();
        pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }
}
