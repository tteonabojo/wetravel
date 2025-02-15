import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_icons.dart';
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${surveyResponse.travelDuration} | ${surveyResponse.companions.join(', ')} | ${surveyResponse.accommodationTypes.join(', ')}',
            style: AppTypography.body2.copyWith(color: AppColors.grayScale_550),
          ),
          Row(
            spacing: 4,
            children: [
              SvgPicture.asset(AppIcons.mapPin,
                  color: AppColors.grayScale_450, height: 16),
              Text(
                surveyResponse.selectedCity ?? '',
                style: AppTypography.body2
                    .copyWith(color: AppColors.grayScale_550),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
