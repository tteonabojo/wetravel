import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomInputField extends StatefulWidget {
  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final Function(String)? onChanged;
  final int maxLength;
  final String labelText;
  final int minLines;
  final int? maxLines;

  const CustomInputField({
    super.key,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.onChanged,
    required this.maxLength,
    required this.labelText,
    this.minLines = 1,
    this.maxLines,
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
    _controller.addListener(_updateCurrentLength);
  }

  @override
  void dispose() {
    _controller.removeListener(_updateCurrentLength);
    _controller.dispose();
    super.dispose();
  }

  int _currentLength = 0;

  void _updateCurrentLength() {
    setState(() {
      _currentLength = _controller.text.length;
      if (_currentLength > widget.maxLength) {
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
      crossAxisAlignment: CrossAxisAlignment.start,
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
            maxLines: widget.maxLines,
            minLines: widget.minLines,
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

// 마이페이지 수정 페이지 위젯
class MyPageCorrection extends StatefulWidget {
  final Color buttonColor;

  MyPageCorrection({super.key, this.buttonColor = Colors.blue});

  @override
  _MyPageCorrectionState createState() => _MyPageCorrectionState();
}

class _MyPageCorrectionState extends State<MyPageCorrection> {
  bool isNicknameValid = false;
  bool isIntroValid = false;

  String? _userEmail;
  File? _profileImage;
  String _nickname = "";
  String _intro = "";

  @override
  void initState() {
    super.initState();
    _getUserEmail();
  }

  Future<void> _getUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userEmail = user.email;
      });
    }
  }

  void _onNicknameChanged(String value) {
    setState(() {
      _nickname = value;
      isNicknameValid = value.isNotEmpty;
    });
  }

  void _onIntroChanged(String value) {
    setState(() {
      _intro = value;
      isIntroValid = value.isNotEmpty;
    });
  }

  bool get isFormValid => isNicknameValid && isIntroValid;

  Future<void> _pickImage() async {
  final ImagePicker picker = ImagePicker();
  try {
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      requestFullMetadata: false, // 메타데이터 요청 방지
    );

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  } on PlatformException catch (e) {
    print("이미지 선택 오류: $e");
  }
}

  Future<void> _saveUserInfo() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'email': _userEmail,
        'nickname': _nickname,
        'intro': _intro,
      }, SetOptions(merge: true));

      Navigator.pushNamed(context, '/survey'); // 설문 페이지로 이동
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Center(
              child: Stack(
                children: [
                  ClipOval(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: _profileImage != null
                            ? DecorationImage(
                                image: FileImage(_profileImage!),
                                fit: BoxFit.cover,
                              )
                            : DecorationImage(
                                image: AssetImage('assets/images/sample_profile.jpg'),
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: _pickImage,
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            CustomInputField(
              hintText: '닉네임을 입력하세요',
              maxLength: 15,
              labelText: '닉네임',
              onChanged: _onNicknameChanged,
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '이메일 주소',
                  style: AppTypography.headline6.copyWith(
                    color: AppColors.grayScale_650,
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 8)),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.grayScale_150,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _userEmail ?? '이메일 정보 없음',
                    style: AppTypography.body1.copyWith(
                      color: AppColors.grayScale_550,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            CustomInputField(
              hintText: '멋진 소개를 부탁드려요!',
              maxLength: 100,
              labelText: '자기소개',
              minLines: 6,
              onChanged: _onIntroChanged,
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFormValid ? AppColors.primary_450 : AppColors.primary_250,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: isFormValid ? _saveUserInfo : null,
                child: Text(
                  '등록',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}