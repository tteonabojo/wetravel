import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/presentation/widgets/custom_input_field.dart';

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

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  TextEditingController _nameController = TextEditingController();

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
        });
      }
    }
  }

  // 이미지 선택 및 Firebase Storage 업로드
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
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
      String filePath = 'profile_images/${user.uid}.jpg';
      UploadTask uploadTask = FirebaseStorage.instance.ref(filePath).putFile(image);
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
      Navigator.pushNamed(context, '/mypage');
    }
  }

  bool get _isFormValid => _isNameValid && _isIntroValid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/mypage', (route) => false),
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
            _buildProfileImage(),
            const SizedBox(height: 20),
            CustomInputField(
              controller: _nameController,
              hintText: _name.isNotEmpty ? _name : '닉네임을 입력하세요',
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
    );
  }

  // 프로필 이미지 위젯
  Widget _buildProfileImage() {
    return Center(
      child: Stack(
        children: [
          ClipOval(
            child: Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: _imageFile != null
                      ? FileImage(_imageFile!)
                      : (_imageUrl != null
                          ? NetworkImage(_imageUrl!) as ImageProvider
                          : const AssetImage('assets/default_profile.png')),
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
                decoration: const BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
                child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
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
        Text('이메일 주소', style: AppTypography.headline6.copyWith(color: AppColors.grayScale_650)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(color: AppColors.grayScale_150, borderRadius: BorderRadius.circular(12)),
          child: Text(_userEmail ?? '이메일 정보 없음', style: AppTypography.body1.copyWith(color: AppColors.grayScale_550)),
        ),
      ],
    );
  }

  // 저장 버튼
  Widget _buildSaveButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: _isFormValid ? AppColors.primary_450 : AppColors.primary_250,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      onPressed: _isFormValid ? _saveUserInfo : null,
      child: const Text('등록', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }
}
