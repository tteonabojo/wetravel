import 'package:flutter/material.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/core/constants/app_colors.dart';

enum ButtonType { primary, secondary }

enum ButtonSizeType { normal, medium }

class StandardButton extends StatefulWidget {
  const StandardButton({
    super.key,
    required this.buttonType,
    required this.sizeType,
    this.isDisabled = false,
    this.icon,
    this.text,
    this.onPressed,
  });

  final ButtonType buttonType;
  final ButtonSizeType sizeType;
  final VoidCallback? onPressed;
  final String? icon;
  final String? text;
  final bool isDisabled;

  @override
  State<StandardButton> createState() => _ButtonState();

  factory StandardButton.primary({
    required final ButtonSizeType sizeType,
    VoidCallback? onPressed,
    String? icon,
    String? text,
    bool isDisabled = false,
  }) =>
      StandardButton(
        buttonType: ButtonType.primary,
        sizeType: sizeType,
        onPressed: onPressed,
        icon: icon,
        text: text,
        isDisabled: isDisabled,
      );

  factory StandardButton.secondary({
    required final ButtonSizeType sizeType,
    VoidCallback? onPressed,
    String? icon,
    String? text,
    bool isDisabled = false,
  }) =>
      StandardButton(
        buttonType: ButtonType.secondary,
        sizeType: sizeType,
        onPressed: onPressed,
        icon: icon,
        text: text,
        isDisabled: isDisabled,
      );
}

class _ButtonState extends State<StandardButton> {
  bool _isPressed = false;
  bool _isHovered = false;

  void _setPressedState(bool isPressed) {
    if (mounted) {
      setState(() => _isPressed = isPressed);
    }
  }

  void _handleTapUp() {
    Future.delayed(const Duration(milliseconds: 100), () {
      _setPressedState(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => _setPressedState(true),
        onTapUp: (_) {
          _handleTapUp();
          widget.onPressed?.call();
        },
        onTapCancel: () => _setPressedState(false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: widget.sizeType == ButtonSizeType.normal ? 52 : 40,
          decoration: _getDecoration(),
          padding: const EdgeInsets.symmetric(horizontal: 30),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.text != null)
                Text(
                  widget.text ?? '',
                  style: _getTypograph(),
                ),
              if (widget.icon != null) ...[
                const SizedBox(width: 8), // 텍스트와 아이콘 사이 간격 8px
                SizedBox(
                  width: widget.sizeType == ButtonSizeType.normal ? 20 : 16,
                  height: widget.sizeType == ButtonSizeType.normal ? 20 : 16,
                  child: Image.asset(widget.icon!),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Decoration _getDecoration() {
    final borderRadius = BorderRadius.circular(12);

    if (widget.isDisabled) {
      switch (widget.buttonType) {
        case ButtonType.primary:
          return BoxDecoration(
            color: AppColors.primary_250,
            borderRadius: borderRadius,
          );
        case ButtonType.secondary:
          return BoxDecoration(
            color: AppColors.primary_050,
            borderRadius: borderRadius,
          );
      }
    }

    if (_isPressed || _isHovered) {
      switch (widget.buttonType) {
        case ButtonType.primary:
          return BoxDecoration(
            color: AppColors.primary_550,
            borderRadius: borderRadius,
          );
        case ButtonType.secondary:
          return BoxDecoration(
            color: AppColors.primary_050,
            borderRadius: borderRadius,
            border: Border.all(
              color: AppColors.primary_450,
            ),
          );
      }
    }

    switch (widget.buttonType) {
      case ButtonType.primary:
        return BoxDecoration(
          color: AppColors.primary_450,
          borderRadius: borderRadius,
        );
      case ButtonType.secondary:
        return BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius,
          border: Border.all(
            color: AppColors.primary_450,
          ),
        );
    }
  }

  TextStyle _getTypograph() {
    final TextStyle textStyle;
    final Color textColor;

    switch (widget.sizeType) {
      case ButtonSizeType.normal:
        textStyle = AppTypography.buttonLabelMedium;
        break;
      case ButtonSizeType.medium:
        textStyle = AppTypography.buttonLabelSmall;
        break;
    }

    switch (widget.buttonType) {
      case ButtonType.primary:
        textColor = Colors.white;
        break;
      case ButtonType.secondary:
        textColor =
            widget.isDisabled ? AppColors.primary_250 : AppColors.primary_450;
        break;
    }

    return textStyle.copyWith(color: textColor);
  }
}
