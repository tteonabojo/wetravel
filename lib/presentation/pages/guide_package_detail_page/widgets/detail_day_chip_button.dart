import 'package:flutter/material.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_spacing.dart';
import 'package:wetravel/core/constants/app_typography.dart';

class DetailDayChipButton extends StatelessWidget {
  final VoidCallback onPressed;
  final int currentDayCount;
  final Function(int) onSelectDay; // 선택된 Day 전달
  final int selectedDay; // 선택된 Day

  const DetailDayChipButton({
    super.key,
    required this.onPressed,
    required this.currentDayCount,
    required this.onSelectDay, // 선택된 Day 전달
    required this.selectedDay, // 선택된 Day
  });

  Widget _buildChip(int index, bool isSelected) {
    return Material(
      color: isSelected ? AppColors.grayScale_650 : AppColors.grayScale_150,
      borderRadius: AppBorderRadius.large20,
      child: InkWell(
        onTap: () => onSelectDay(index + 1),
        borderRadius: AppBorderRadius.large20,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            'Day ${index + 1}',
            style: AppTypography.buttonLabelSmall.copyWith(
              color: isSelected ? Colors.white : AppColors.grayScale_450,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.small4,
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: 8,
        children: List.generate(
          currentDayCount,
          (index) {
            bool isSelected = selectedDay == index + 1;
            return _buildChip(index, isSelected);
          },
        ),
      ),
    );
  }
}
