import 'package:flutter/material.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_typography.dart';

class CustomInputField extends StatefulWidget {
  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final Function(String)? onChanged;
  final int maxLength;
  final String labelText;
  final TextEditingController? controller;
  final int? maxLines;
  final int? minLines;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final Alignment? counterAlignment; // Align 부분을 nullable로 변경

  const CustomInputField({
    super.key,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.onChanged,
    required this.maxLength,
    required this.labelText,
    this.controller,
    this.maxLines = 1,
    this.minLines = 1,
    this.validator,
    this.focusNode,
    this.counterAlignment, // Align 부분을 nullable로 변경
  });

  @override
  State<CustomInputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<CustomInputField> {
  late final TextEditingController _controller;
  int _currentLength = 0;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_updateCurrentLength);
  }

  @override
  void dispose() {
    _controller.removeListener(_updateCurrentLength);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _updateCurrentLength() {
    setState(() {
      _currentLength = _controller.text.length;
      if (_currentLength > widget.maxLength) {
        _controller.text = _controller.text.substring(0, widget.maxLength);
        _currentLength = widget.maxLength;
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _currentLength),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labelText,
          style: AppTypography.headline6.copyWith(
            color: AppColors.grayScale_650,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _controller,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          onChanged: widget.onChanged,
          validator: widget.validator,
          style: const TextStyle(color: AppColors.grayScale_750),
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: AppTypography.body1.copyWith(
              color: AppColors.grayScale_350,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppBorderRadius.small12,
              borderSide: const BorderSide(color: AppColors.primary_450),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppBorderRadius.small12,
              borderSide: const BorderSide(color: AppColors.grayScale_150),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: AppBorderRadius.small12,
              borderSide: const BorderSide(color: AppColors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: AppBorderRadius.small12,
              borderSide: const BorderSide(color: AppColors.red),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
        if (widget.counterAlignment != null)
          Align(
            alignment: widget.counterAlignment!,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                '$_currentLength / ${widget.maxLength}',
                style: AppTypography.body2.copyWith(
                  color: AppColors.grayScale_350,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
