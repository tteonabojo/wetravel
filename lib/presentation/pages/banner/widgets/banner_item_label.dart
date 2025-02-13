import 'package:flutter/material.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_typography.dart';

class BannerItemLabel extends StatelessWidget {
  final String label;
  const BannerItemLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTypography.headline6.copyWith(
        color: AppColors.grayScale_650,
      ),
    );
  }
}
