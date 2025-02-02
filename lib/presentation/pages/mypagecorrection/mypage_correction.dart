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
  final int minLines; // 최소 줄 수
  final int? maxLines; // 최대 줄 수

  const CustomInputField({
    super.key,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.onChanged,
    required this.maxLength,
    required this.labelText, // labelText 필수
    this.minLines = 1, // 기본 최소 줄 수 설정
    this.maxLines, // 최대 줄 수는 지정하지 않으면 자유롭게 늘어남
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
              color: AppColors.grayScale_750,
            ),
            maxLines: widget.maxLines, // 입력 줄 수 제한
            minLines: widget.minLines, // 최소 줄 수 설정
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: AppTypography.body1.copyWith(
                color: AppColors.grayScale_350,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primary_450,
                ),
              ),
              enabledBorder: OutlineInputBorder(
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

class MyPageCorrection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 버튼 누르면 이전 화면으로 돌아감
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20), // 여백 20
            Center(
              child: ClipOval(
                child: Container(
                  width: 82,
                  height: 82, // 높이와 너비를 동일하게 설정하여 원형 만들기
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage('https://picsum.photos/82'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20), // 여백 20
            CustomInputField(
              hintText: '닉네임을 입력하세요',
              keyboardType: TextInputType.text,
              obscureText: false,
              maxLength: 15,
              labelText: '닉네임',
            ),
            SizedBox(height: 20), // 여백 20
            CustomInputField(
              hintText: '이메일을 입력하세요',
              keyboardType: TextInputType.emailAddress,
              obscureText: false,
              maxLength: 20,
              labelText: '이메일주소',
            ),
            SizedBox(height: 20), // 여백 20
            Container(
              child: CustomInputField(
                hintText: '멋진 소개를 부탁드려요!',
                keyboardType: TextInputType.text,
                obscureText: false,
                maxLength: 100,
                labelText: '자기소개',
                minLines: 6, // 최소 3줄로 시작, 필요에 따라 늘어남
              ),
            ),
          ],
        ),
      ),
    );
  }
}
