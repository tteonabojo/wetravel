import 'package:flutter/material.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_colors.dart';

class DeleteDayButton extends StatefulWidget {
  final VoidCallback? onPressed;

  const DeleteDayButton({super.key, this.onPressed});

  @override
  _DeleteDayButtonState createState() => _DeleteDayButtonState();
}

class _DeleteDayButtonState extends State<DeleteDayButton> {
  bool _isPressed = false;
  bool _isHovered = false;

  bool get _isActive => _isHovered || _isPressed;

  void _handleTap() {
    widget.onPressed?.call();
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => _handleTap(),
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: double.infinity,
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: ShapeDecoration(
            color:
                _isActive ? AppColors.grayScale_250 : AppColors.grayScale_150,
            shape: RoundedRectangleBorder(
              borderRadius: AppBorderRadius.small12,
            ),
          ),
          child: const Center(
            child: Text(
              '해당 Day 전체일정 삭제',
              style: TextStyle(
                color: AppColors.red,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
