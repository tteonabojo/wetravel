import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_icons.dart';
import 'package:wetravel/core/constants/app_spacing.dart';
import 'package:wetravel/core/constants/app_typography.dart';

enum DisabledType { disabled50, disabled150 }

class DayChipButton extends StatefulWidget {
  final VoidCallback onPressed;
  final int currentDayCount;
  final Function(int) onSelectDay; // 선택된 Day 전달
  final int selectedDay; // 선택된 Day

  const DayChipButton({
    super.key,
    required this.onPressed,
    required this.currentDayCount,
    required this.onSelectDay, // 선택된 Day 전달
    required this.selectedDay, // 선택된 Day
  });

  @override
  _DayChipButtonState createState() => _DayChipButtonState();
}

class _DayChipButtonState extends State<DayChipButton> {
  bool _isHovered = false;

  void _handleAddDay() {
    if (widget.currentDayCount >= 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('등록 가능한 여행일정은 최대 10일입니다.'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      widget.onPressed();
    }
  }

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
                  : AppColors.grayScale_150, // 선택된 상태 색상
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
                      color: isSelected
                          ? Colors.white
                          : AppColors.grayScale_450, // 선택된 상태 텍스트 색상
                    ),
                  ),
                ),
              ),
            );
          }),
          MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: Material(
              color: _isHovered
                  ? AppColors.grayScale_250
                  : AppColors.grayScale_150,
              borderRadius: AppBorderRadius.large20,
              child: InkWell(
                onTap: _handleAddDay, // 플러스 버튼 클릭 시 처리
                borderRadius: AppBorderRadius.large20,
                child: Padding(
                  padding: AppSpacing.small8,
                  child: SvgPicture.asset(
                    AppIcons.plus,
                    color: AppColors.grayScale_450,
                    height: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
