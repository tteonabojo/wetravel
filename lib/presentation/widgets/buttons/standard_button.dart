import 'package:flutter/material.dart';
import 'package:wetravel/constants/app_typography.dart';
import 'package:wetravel/constants/app_colors.dart';

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

  void _onPressed({required bool isPressed}) {
    if (_isPressed == isPressed) return;

    setState(() => _isPressed = isPressed);
  }

  @override
  Widget build(BuildContext context) {
    // 버튼 누르고 뗄 때를 감지함
    return GestureDetector(
      // 버튼에서 손 떼는 순간
      onTapUp: (_) {
        _onPressed(isPressed: false);
        widget.onPressed?.call();
      },
      // 버튼 누르는 순간
      onTapDown: (_) => _onPressed(isPressed: true),
      // 버튼 누르다가 갑자기 취소되는 순간
      onTapCancel: () => _onPressed(isPressed: false),
      // 버튼 누르고 뗄 때의 색상변화
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: widget.sizeType == ButtonSizeType.normal ? 52 : 40,
        decoration: _getDecoration(),
        padding: EdgeInsets.symmetric(horizontal: 30),
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
    );
  }

  Decoration _getDecoration() {
    final borderRadius = BorderRadius.circular(12);
    if (widget.isDisabled) {
      // Disabled 상태의 색상
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
    } else if (_isPressed) {
      // Hover 상태의 색상
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
    } else {
      // Default 상태의 색상
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
  }

  TextStyle _getTypograph() {
    final TextStyle textStyle;
    final Color textColor;

    // 글꼴 스타일 설정
    switch (widget.sizeType) {
      case ButtonSizeType.normal:
        textStyle = AppTypography.buttonLabelMedium; // normal 버튼의 텍스트 스타일
        break;
      case ButtonSizeType.medium:
        textStyle = AppTypography.buttonLabelSmall; // medium 버튼의 텍스트 스타일
        break;
    }

    // 글자 색상 설정
    switch (widget.buttonType) {
      case ButtonType.primary:
        textColor = Colors.white; // primary 버튼은 항상 흰색 텍스트
        break;
      case ButtonType.secondary:
        if (widget.isDisabled) {
          textColor = AppColors.primary_250; // disabled 상태의 텍스트 색상
        } else {
          textColor = AppColors.primary_450; // default 및 hover 상태의 텍스트 색상
        }
        break;
    }

    // 최종 텍스트 스타일 반환
    return textStyle.copyWith(color: textColor);
  }
}
