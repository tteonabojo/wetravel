import 'package:flutter/material.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_spacing.dart';
import 'package:wetravel/core/constants/app_typography.dart';

enum DisabledType { disabled50, disabled150 }

class DetailDayChipButton extends StatefulWidget {
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

  @override
  _DayChipButtonState createState() => _DayChipButtonState();
}

class _DayChipButtonState extends State<DetailDayChipButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.small4,
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: 8,
        children: [
          ...List.generate(widget.currentDayCount, (index) {
            bool isSelected = widget.selectedDay == index + 1;
            return Material(
              color: isSelected
                  ? AppColors.grayScale_650
                  : AppColors.grayScale_150,
              borderRadius: AppBorderRadius.large20,
              child: InkWell(
                onTap: () => widget.onSelectDay(index + 1),
                borderRadius: AppBorderRadius.large20,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Text(
                    'Day ${index + 1}',
                    style: AppTypography.buttonLabelSmall.copyWith(
                      color:
                          isSelected ? Colors.white : AppColors.grayScale_450,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
