import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/domain/entity/survey_response.dart';
import 'package:wetravel/presentation/widgets/buttons/standard_button.dart';

class BottomButtons extends StatelessWidget {
  final VoidCallback onRecommendationPressed;
  final String? selectedDestination;
  final SurveyResponse surveyResponse;
  final bool isAdLoading;

  const BottomButtons({
    super.key,
    required this.onRecommendationPressed,
    required this.selectedDestination,
    required this.surveyResponse,
    this.isAdLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide(color: AppColors.primary_450),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: isAdLoading ? null : onRecommendationPressed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isAdLoading) ...[
                    SvgPicture.asset(
                      'assets/icons/play.svg',
                      color: AppColors.primary_450,
                      height: 16,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    isAdLoading ? '광고 로딩 중...' : '다시 추천받기',
                    style: AppTypography.buttonLabelSmall.copyWith(
                      color: AppColors.primary_450,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: StandardButton.primary(
              sizeType: ButtonSizeType.normal,
              onPressed: selectedDestination != null
                  ? () {
                      final updatedSurveyResponse = surveyResponse.copyWith(
                        selectedCity: selectedDestination,
                      );
                      Navigator.pushNamed(
                        context,
                        '/ai-schedule',
                        arguments: updatedSurveyResponse,
                      );
                    }
                  : null,
              text: '다음으로',
            ),
          ),
        ],
      ),
    );
  }
}
