import 'package:flutter/material.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_typography.dart';

class RecommendationHeader extends StatelessWidget {
  const RecommendationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.grayScale_050,
          borderRadius: AppBorderRadius.small12,
        ),
        child: Text(
          '리스트를 확인하고 나에게 맞는 여행지를 선택해주세요',
          style: AppTypography.body2.copyWith(
            color: AppColors.grayScale_450,
          ),
        ),
      ),
    );
  }
}
