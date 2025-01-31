import 'package:flutter/material.dart';
import 'package:wetravel/constants/app_colors.dart';
import 'package:wetravel/constants/app_typography.dart';

enum DisabledType { disabled50, disabled150 }
// 비활성 상태일때의 디자인 선택 가능 -> disabled 50 또는 disabled 150

class ChipButton extends StatelessWidget {
  const ChipButton({
    super.key,
    required this.text,
    required this.isSelected,
    this.disabledType = DisabledType.disabled50, // 기본 비활성 상태 디자인 : disabled 50
    required this.onPressed,
  });

  final String text;
  final bool isSelected;
  final DisabledType disabledType;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected
          ? AppColors.grayScale_650
          : disabledType == DisabledType.disabled50
              ? AppColors.grayScale_050
              : AppColors.grayScale_150,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            text,
            style: AppTypography.buttonLabelSmall.copyWith(
              color: isSelected
                  ? Colors.white
                  : disabledType == DisabledType.disabled50
                      ? AppColors.grayScale_350
                      : AppColors.grayScale_450,
            ),
          ),
        ),
      ),
    );
  }
}
