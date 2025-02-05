import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
    _controller.addListener(_updateCurrentLength); // 리스너 등록: 입력 변화 감지
  }

  @override
  void dispose() {
    _controller.removeListener(_updateCurrentLength); // 리스너 제거
    _controller.dispose();
    super.dispose();
  }

  int _currentLength = 0; // 현재 입력 글자 수

  void _updateCurrentLength() {
    setState(() {
      _currentLength = _controller.text.length; // 현재 글자 수 갱신
      if (_currentLength > widget.maxLength) {
        // 최대 글자 수 초과 시
        _controller.text =
            _controller.text.substring(0, widget.maxLength); // 입력 제한
        _currentLength = widget.maxLength; // 현재 글자 수 최대 값으로 설정
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

  const MyPageCorrection({super.key, this.buttonColor = Colors.blue});

  @override
  _MyPageCorrectionState createState() => _MyPageCorrectionState();
}

class _MyPageCorrectionState extends State<MyPageCorrection> {
  bool isNicknameValid = false; // 닉네임 유효성 검사 결과
  bool isIntroValid = false; // 소개글 유효성 검사 결과

  String? _userEmail; // 사용자 이메일
  File? _profileImage; // 프로필 이미지 파일
  String _nickname = ""; // 닉네임
  String _intro = ""; // 자기소개

  String _originalNickname = ""; // 초기 닉네임
  String _originalIntro = ""; // 초기 자기소개 글

  bool get isNicknameChanged => _nickname != _originalNickname; // 닉네임 변경 여부 확인
  bool get isIntroChanged => _intro != _originalIntro; // 소개글 변경 여부 확인

  @override
  void initState() {
    super.initState();
    _getUserEmail(); // 사용자 이메일 정보 가져오는 거
  }

  // 사용자 이메일 정보 가져오기
  Future<void> _getUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userEmail = user.email;
      });
    }
  }

  // 닉네임 입력 변화 감지
  void _onNicknameChanged(String value) {
    setState(() {
      _nickname = value;
      isNicknameValid = value.isNotEmpty;
    });
  }

  // 소개글 입력 변화 감지
  void _onIntroChanged(String value) {
    setState(() {
      _intro = value;
      isIntroValid = value.isNotEmpty;
    });
  }

  // 폼 유효성 검사
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
      print("이미지 선택 오류: $e"); // 오류 발생시 콘솔에 출력
    }
  }

  Future<void> _saveUserInfo() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String? imageUrl;

      // 프로필 이미지가 변경돠었을 경우 Firebase Storage에 업로드
      if (_profileImage != null) {
        final storageRef = FirebaseStorage.instance.ref();
        final profileRef = storageRef.child("profile_images/${user.uid}.jpg");

        try {
          await profileRef.putFile(_profileImage!);
          imageUrl = await profileRef.getDownloadURL();
        } catch (e) {
          print("이미지 업로드 실패: $e");
        }
      }
      // Firestore 업데이트
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'email': _userEmail,
        'nickname': _nickname,
        'intro': _intro,
        if (imageUrl != null) 'profileImageUrl': imageUrl, // 프로필 이미지 변경시 반영
      }, SetOptions(merge: true));

      // 마이페이지로 이동하면서 최신 데이터 반영
      Navigator.pushNamed(context, '/mypage');
    }
  }

  // 뒤로가기 시 데이터 변경 여부 확인
  Future<bool> _onWillPop() async {
    if (isNicknameChanged || isIntroChanged) {
      return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("변경 사항이 있습니다."),
              content: const Text("변경 내용을 저장하지 않고 나가시겠습니까?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("취소"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context)
                      .pushNamedAndRemoveUntil('/mypage', (route) => false),
                  child: const Text("나가기"),
                ),
              ],
            ),
          ) ??
          false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () async {
                bool shouldPop = await _onWillPop();
                if (shouldPop && mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/mypage', (route) => false);
                }
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
                const SizedBox(height: 20),
                Center(
                  child: Stack(
                    children: [
                      ClipOval(
                        child: Container(
                          width: 82,
                          height: 82,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: _profileImage != null
                                ? DecorationImage(
                                    image: FileImage(_profileImage!),
                                    fit: BoxFit.cover,
                                  )
                                : const DecorationImage(
                                    image: AssetImage(
                                        'assets/images/sample_profile.jpg'),
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
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                      backgroundColor: isFormValid
                          ? AppColors.primary_450
                          : AppColors.primary_250,
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
        ));
  }
}
