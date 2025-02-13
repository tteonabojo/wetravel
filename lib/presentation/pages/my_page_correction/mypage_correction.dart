import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/presentation/widgets/custom_input_field.dart';
import 'package:image/image.dart' as img;

class MyPageCorrection extends StatefulWidget {
  const MyPageCorrection({super.key});

  @override
  _MyPageCorrectionState createState() => _MyPageCorrectionState();
}

class _MyPageCorrectionState extends State<MyPageCorrection> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  String? _userEmail;
  String? _imageUrl;
  File? _imageFile;
  String _name = "";
  String _intro = "";
  bool _isNameValid = false;
  bool _isIntroValid = false;
  String _initialName = "";
  String _initialIntro = "";

  TextEditingController _nameController = TextEditingController();
  TextEditingController _introController = TextEditingController();

  bool _isChanged() {
    return _name != _initialName ||
        _intro != _initialIntro ||
        _imageFile != null;
  }

  @override
  void initState() {
    super.initState();
    _getUserData();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
  }
  
  // Firestore에서 사용자 데이터 가져오기
  Future<void> _getUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          _userEmail = data['email'];
          _name = data['name'] ?? '';
          _intro = data['intro'] ?? '';
          _imageUrl = data['imageUrl'];
          _isNameValid = _name.isNotEmpty;
          _isIntroValid = _intro.isNotEmpty;
          _nameController.text = _name;
          _introController.text = _intro;
          _initialName = _name;
          _initialIntro = _intro;
        });
      }
    }
  }

  // 이미지 선택 및 Firebase Storage 업로드
  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    File imageFile = File(pickedFile.path);
    setState(() => _imageFile = imageFile);

    await _uploadImageToFirebase(imageFile);
  }

  // Firebase Storage에 이미지 업로드 후 URL 반환
  Future<void> _uploadImageToFirebase(File image) async {
    User? user = _auth.currentUser;
    if (user == null) return;

    try {
      // 이미지 파일을 Uint8List로 변환
      Uint8List imageBytes = await image.readAsBytesSync();

      // 이미지 디코딩 및 리사이징 (300*300)
      img.Image? originalImage = img.decodeImage(imageBytes);
      if (originalImage == null) throw Exception("이미지 디코딩 실패");

      img.Image resizedImage = img.copyResize(originalImage, width:300, height: 300);

      // JPG로 변환 및 품질 85%로 설정
      Uint8List compressedImage = Uint8List.fromList(img.encodeJpg(resizedImage, quality: 85));

      // Firebase Storage에 업로드
      String filePath = 'profile_images/${user.uid}.jpg';
      UploadTask uploadTask =
          FirebaseStorage.instance.ref(filePath).putData(compressedImage);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() => _imageUrl = downloadUrl);

      // Firestore에 이미지 URL 저장
      await _firestore.collection('users').doc(user.uid).update({
        'imageUrl': downloadUrl,
      });
    } catch (e) {
      print("이미지 업로드 오류: $e");
    }
  }

  // 사용자 정보 Firestore에 저장
  Future<void> _saveUserInfo() async {
    User? user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('users').doc(user.uid).set({
      'name': _name,
      'intro': _intro,
      'imageUrl': _imageUrl,
    }, SetOptions(merge: true));

    if (mounted) {
      Navigator.pop(context);
    }
  }

  bool get _isFormValid => _isNameValid && _isIntroValid;

  Future<bool> _showExitConfirmationDialog() async {
    return await showCupertinoDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            '프로필 설정에서 나가시겠어요?',
            style: AppTypography.headline6.copyWith(
              fontSize: 18,
              color: AppColors.grayScale_950,
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '변경사항이 저장되지 않아요.',
              style: AppTypography.body2.copyWith(
                fontSize: 14,
                color: AppColors.grayScale_650,
              ),
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () =>
                  Navigator.of(context).pop(false), // 취소 시 false 반환
              child: Text(
                '취소',
                style: AppTypography.body1.copyWith(
                  color: AppColors.primary_450,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(true), // 나가기 시 true 반환
              isDestructiveAction: true,
              child: Text(
                '나가기',
                style: AppTypography.body1.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    ).then((value) => value ?? false); // 다이얼로그가 닫힐 때 기본값 false 반환
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isChanged()) {
          return await _showExitConfirmationDialog();
        }
        return true; // 변경사항이 없으면 바로 뒤로 가기
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () async {
              if (_isChanged()) {
                if (await _showExitConfirmationDialog()) {
                  Navigator.pop(context);
                }
              } else {
                Navigator.pop(context);
              }
            },
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          // 키보드가 올라와도 스크롤 가능하도록 변경
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              _buildProfileImage(),
              const SizedBox(height: 20),
              CustomInputField(
                controller: _nameController,
                hintText: _name.isNotEmpty ? _name : '닉네임을 입력하세요.',
                maxLength: 15,
                labelText: '닉네임',
                onChanged: (value) => setState(() {
                  _name = value;
                  _isNameValid = value.isNotEmpty;
                }),
              ),
              const SizedBox(height: 20),
              _buildEmailField(),
              const SizedBox(height: 20),
              CustomInputField(
                controller: _introController,
                hintText: '멋진 소개를 부탁드려요!',
                maxLength: 100,
                labelText: '자기소개',
                minLines: 6,
                maxLines: 6,
                onChanged: (value) => setState(() {
                  _intro = value;
                  _isIntroValid = value.isNotEmpty;
                }),
              ),
              const SizedBox(height: 16),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  // 프로필 이미지 위젯
Widget _buildProfileImage() {
  bool isValidUrl = _imageUrl != null && _imageUrl!.startsWith('http');

  return Center(
    child: Stack(
      children: [
        GestureDetector( // 프로필 이미지 전체를 클릭 가능하게 변경
          onTap: _pickImage,
          child: ClipOval(
            child: Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.primary_250,
                image: isValidUrl
                    ? DecorationImage(
                        image: NetworkImage(_imageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: isValidUrl
                  ? null
                  : const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 40,
                    ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: InkWell(
            onTap: _pickImage, // 기존 아이콘 클릭 기능 유지
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
              child:
                  const Icon(Icons.camera_alt, color: Colors.white, size: 20),
            ),
          ),
        ),
      ],
    ),
  );
}

  // 이메일 필드
  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('이메일 주소',
            style: AppTypography.headline6
                .copyWith(color: AppColors.grayScale_650)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
              color: AppColors.grayScale_150,
              borderRadius: BorderRadius.circular(12)),
          child: Text(_userEmail ?? '이메일 정보 없음',
              style:
                  AppTypography.body1.copyWith(color: AppColors.grayScale_550)),
        ),
      ],
    );
  }

  // 저장 버튼
  Widget _buildSaveButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor:
            _isFormValid ? AppColors.primary_450 : AppColors.primary_250,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      onPressed: _isFormValid ? _saveUserInfo : null,
      child: const Text('등록',
          style: TextStyle(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }
}
