import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_icons.dart';
import 'package:wetravel/core/constants/app_spacing.dart';
import 'package:wetravel/core/constants/app_typography.dart';

class DayChipButton extends StatelessWidget {
  final VoidCallback onPressed;
  final int currentDayCount;
  final Function(int) onSelectDay;
  final int selectedDay;

  const DayChipButton({
    super.key,
    required this.onPressed,
    required this.currentDayCount,
    required this.onSelectDay,
    required this.selectedDay,
  });

  void _handleAddDay(BuildContext context) {
    if (currentDayCount >= 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('등록 가능한 여행일정은 최대 10일입니다.'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      onPressed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.small4,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...List.generate(currentDayCount, (index) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: DayButton(
                dayIndex: index + 1,
                isSelected: selectedDay == index + 1,
                onSelectDay: onSelectDay,
              ),
            );
          }),
          AddDayButton(onPressed: () => _handleAddDay(context)),
        ],
      ),
    );
  }
}

/// 몇일차 선택버튼
class DayButton extends StatelessWidget {
  final int dayIndex;
  final bool isSelected;
  final Function(int) onSelectDay;

  const DayButton({
    required this.dayIndex,
    required this.isSelected,
    required this.onSelectDay,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? AppColors.grayScale_650 : AppColors.grayScale_150,
      borderRadius: AppBorderRadius.large20,
      child: InkWell(
        onTap: () => onSelectDay(dayIndex),
        borderRadius: AppBorderRadius.large20,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            'Day $dayIndex',
            style: AppTypography.buttonLabelSmall.copyWith(
              color: isSelected ? Colors.white : AppColors.grayScale_450,
            ),
          ),
        ),
      ),
    );
  }
}

/// 일수 추가 버튼
class AddDayButton extends StatefulWidget {
  final VoidCallback onPressed;

  const AddDayButton({required this.onPressed, super.key});

  @override
  _AddDayButtonState createState() => _AddDayButtonState();
}

class _AddDayButtonState extends State<AddDayButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Material(
        color: _isHovered ? AppColors.grayScale_250 : AppColors.grayScale_150,
        borderRadius: AppBorderRadius.large20,
        child: InkWell(
          onTap: widget.onPressed,
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
    );
  }
}
