import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wetravel/constants/app_colors.dart';
import 'package:wetravel/constants/app_typography.dart'; // AppColors 임포트 확인

class CustomInputField extends StatefulWidget {
  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final Function(String)? onChanged;
  final int maxLength; // 최대 글자 수
  final String labelText; // 고정 라벨 텍스트 추가

  const CustomInputField({
    super.key,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.onChanged,
    required this.maxLength,
    required this.labelText, // labelText 필수
  });

  @override
  State<CustomInputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<CustomInputField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_updateCurrentLength); // 리스너 추가
  }

  @override
  void dispose() {
    _controller.removeListener(_updateCurrentLength); // 리스너 제거

    _controller.dispose();
    super.dispose();
  }

  int _currentLength = 0;

  void _updateCurrentLength() {
    setState(() {
      _currentLength = _controller.text.length;
      if (_currentLength > widget.maxLength) {
        // 추가: 최대 글자 수 초과 시 텍스트 자르기
        _controller.text = _controller.text.substring(0, widget.maxLength);
        _currentLength = widget.maxLength;
        _controller.selection =
            TextSelection.fromPosition(TextPosition(offset: _currentLength));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
      children: [
        Text(
          widget.labelText,
          style: AppTypography.headline6.copyWith(
            color: AppColors.grayScale_650,
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 8)),
        Focus(
          child: TextFormField(
            controller: _controller,
            keyboardType: widget.keyboardType,
            obscureText: widget.obscureText,
            onChanged: widget.onChanged,
            style: TextStyle(
              // 입력 글씨 색상 설정
              color: AppColors.grayScale_750,
            ),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: AppTypography.body1.copyWith(
                // 힌트 글씨 색상 설정
                color: AppColors.grayScale_350,
              ),
              focusedBorder: OutlineInputBorder(
                // 입력 중 테두리 스타일
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primary_450,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                // 비활성 테두리 스타일
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.grayScale_150,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                '${_currentLength} / ${widget.maxLength}',
                style: AppTypography.body2
                    .copyWith(color: AppColors.grayScale_350),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
