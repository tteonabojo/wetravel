import 'package:flutter/material.dart';
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
    // 외부 컨트롤러가 있으면 사용하고, 없으면 내부에서 생성
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_updateCurrentLength);
  }

  @override
  void dispose() {
    _controller.removeListener(_updateCurrentLength);
    if (widget.controller == null) {
      // 외부 컨트롤러가 아닌 경우에만 dispose
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
          style: const TextStyle(color: AppColors.grayScale_750),
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: AppTypography.body1.copyWith(
              color: AppColors.grayScale_350,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary_450),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.grayScale_150),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
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
