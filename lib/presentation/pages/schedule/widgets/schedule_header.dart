import 'package:flutter/material.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/domain/entity/survey_response.dart';

class ScheduleHeader extends StatelessWidget {
  final SurveyResponse surveyResponse;

  const ScheduleHeader({
    super.key,
    required this.surveyResponse,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${surveyResponse.travelDuration} | ${surveyResponse.companions.join(', ')} | ${surveyResponse.accommodationTypes.join(', ')}',
          style: AppTypography.body2.copyWith(
            color: AppColors.grayScale_450,
          ),
        ),
        Row(
          children: [
            Icon(Icons.location_on_outlined,
                color: AppColors.grayScale_450, size: 20),
            const SizedBox(width: 4),
            Text(
              surveyResponse.selectedCity ?? '',
              style: AppTypography.body2.copyWith(
                color: AppColors.grayScale_450,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
