import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_icons.dart';

class AddItineraryButton extends StatefulWidget {
  final VoidCallback? onPressed;

  const AddItineraryButton({super.key, this.onPressed});

  /// Factory 생성자 추가
  factory AddItineraryButton.create({VoidCallback? onPressed}) {
    return AddItineraryButton(onPressed: onPressed);
  }

  @override
  _AddItineraryButtonState createState() => _AddItineraryButtonState();
}

class _AddItineraryButtonState extends State<AddItineraryButton> {
  bool _isPressed = false;
  bool _isHovered = false;

  void _handleTapUp() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _isPressed = false;
        });
      }
    });
    widget.onPressed?.call();
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
            child: SvgPicture.asset(
              AppIcons.plus,
              width: 24,
              height: 24,
              color: AppColors.grayScale_450,
            ),
          ),
        ),
      ),
    );
  }
}
