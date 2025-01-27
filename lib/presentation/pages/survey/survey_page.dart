import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/presentation/pages/plan_selection/plan_selection_page.dart';
import 'widgets/survey_step_indicator.dart';
import '../../provider/survey_provider.dart';
import 'widgets/selection_item.dart';

class SurveyPage extends ConsumerStatefulWidget {
  const SurveyPage({super.key});

  @override
  ConsumerState<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends ConsumerState<SurveyPage> {
  int currentStep = 0;

  String _getStepTitle(int step) {
    switch (step) {
      case 0:
        return '언제 떠나실\n계획이신가요?';
      case 1:
        return '여행 기간은\n어떻게 되시나요?';
      case 2:
        return '누구와\n가시나요?';
      case 3:
        return '이번 여행의\n스타일을 알려주세요';
      case 4:
        return '선호하는\n숙소 스타일을 알려주세요';
      case 5:
        return '특별히 피하고 싶은\n사항을 알려주세요';
      default:
        return '';
    }
  }

  Widget _buildStepContent(int step) {
    switch (step) {
      case 0:
        return _buildSelectionGrid([
          '일주일 이내',
          '1개월 이내',
          '3개월 이내',
          '일정 계획 없음',
        ], 2);
      case 1:
        return _buildSelectionGrid([
          '1박 2일',
          '2박 3일',
          '3박 4일',
          '4박 5일',
          '6박 7일',
          '그 이상',
        ], 3);
      case 2:
        return _buildSelectionGrid([
          '혼자',
          '연인과',
          '가족과',
          '친구와',
        ], 2);
      case 3:
        return _buildSelectionGrid([
          '액티비티',
          '휴양',
          '자연',
          '관광',
          '쇼핑',
        ], 2);
      case 4:
        return _buildSelectionGrid([
          '호텔',
          '게스트하우스',
          '에어비앤비',
          '캠핑',
        ], 2);
      case 5:
        return _buildSelectionGrid([
          '기온',
          '언어',
          '시차 적응',
          '치안',
          '없음',
        ], 2);
      default:
        return Container();
    }
  }

  Widget _buildSelectionGrid(List<String> items, int crossAxisCount) {
    final survey = ref.watch(surveyProvider);

    String? selectedValue;
    switch (currentStep) {
      case 0:
        selectedValue = survey.travelTiming;
        break;
      case 1:
        selectedValue = survey.travelDuration;
        break;
      case 2:
        selectedValue = survey.companion;
        break;
      case 3:
        selectedValue = survey.travelStyle;
        break;
      case 4:
        selectedValue = survey.accommodation;
        break;
      case 5:
        selectedValue = survey.concerns;
        break;
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 2.5,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final isSelected = items[index] == selectedValue;

        return SelectionItem(
          text: items[index],
          isSelected: isSelected,
          onTap: () {
            switch (currentStep) {
              case 0:
                ref
                    .read(surveyProvider.notifier)
                    .updateTravelTiming(items[index]);
                break;
              case 1:
                ref
                    .read(surveyProvider.notifier)
                    .updateTravelDuration(items[index]);
                break;
              case 2:
                ref.read(surveyProvider.notifier).updateCompanion(items[index]);
                break;
              case 3:
                ref
                    .read(surveyProvider.notifier)
                    .updateTravelStyle(items[index]);
                break;
              case 4:
                ref
                    .read(surveyProvider.notifier)
                    .updateAccommodation(items[index]);
                break;
              case 5:
                ref.read(surveyProvider.notifier).updateConcerns(items[index]);
                break;
            }
          },
        );
      },
    );
  }

  void _handleBack() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  bool _canProceedToNextStep() {
    final survey = ref.read(surveyProvider);

    switch (currentStep) {
      case 0:
        return survey.travelTiming != null;
      case 1:
        return survey.travelDuration != null;
      case 2:
        return survey.companion != null;
      case 3:
        return survey.travelStyle != null;
      case 4:
        return survey.accommodation != null;
      case 5:
        return survey.concerns != null;
      default:
        return false;
    }
  }

  void _showValidationError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('항목을 선택해주세요'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (currentStep > 0) {
          setState(() {
            currentStep--;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _handleBack,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SurveyStepIndicator(currentStep: currentStep),
                const SizedBox(height: 24),
                Text(
                  _getStepTitle(currentStep),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: _buildStepContent(currentStep),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (currentStep < 5) {
                      if (_canProceedToNextStep()) {
                        setState(() {
                          currentStep++;
                        });
                      } else {
                        _showValidationError();
                      }
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const PlanSelectionPage(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: Text(currentStep < 5 ? '다음으로' : '완료'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
