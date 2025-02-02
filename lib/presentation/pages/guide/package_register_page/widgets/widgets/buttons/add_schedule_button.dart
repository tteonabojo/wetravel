import 'package:flutter/material.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_typography.dart';

class AddScheduleButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final int currentScheduleCount;

  const AddScheduleButton({
    super.key,
    this.onPressed,
    required this.currentScheduleCount,
  });

  @override
  _AddScheduleButtonState createState() => _AddScheduleButtonState();
}

class _AddScheduleButtonState extends State<AddScheduleButton> {
  static const int maxSchedulesPerDay = 9;
  bool _isPressed = false;
  bool _isHovered = false;

  void _handleTapUp() {
    setState(() => _isPressed = false);

    if (widget.currentScheduleCount < maxSchedulesPerDay) {
      widget.onPressed?.call();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('일정은 하루 최대 10개입니다.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => _handleTapUp(),
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: double.infinity,
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: ShapeDecoration(
            color: (_isPressed || _isHovered)
                ? AppColors.grayScale_250
                : AppColors.grayScale_150,
            shape: RoundedRectangleBorder(
              borderRadius: AppBorderRadius.small12,
            ),
          ),
          child: Center(
            child: Text(
              '일정 추가',
              style: AppTypography.buttonLabelMedium
                  .copyWith(color: AppColors.grayScale_550),
            ),
          ),
        ),
      ),
    );
  }
}
