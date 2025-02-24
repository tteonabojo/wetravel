import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/domain/usecase/update_user_profile_usecase.dart';
import 'package:wetravel/domain/usecase/upload_profile_image_usecase.dart';
import 'package:wetravel/domain/usecase/get_user_data_usecase.dart';
import 'package:wetravel/domain/usecase/delete_account_usecase.dart';
import 'package:wetravel/core/di/injection_container.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wetravel/domain/entity/user.dart';
import 'package:wetravel/presentation/pages/login/login_page.dart';
import 'package:wetravel/presentation/pages/my_page/my_page.dart';

class MyPageCorrectionViewModel extends ChangeNotifier {
  final UpdateUserProfileUseCase _updateUserProfileUseCase;
  final UploadProfileImageUseCase _uploadProfileImageUseCase;
  final GetUserDataUseCase _getUserDataUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;
  final ImagePicker _picker = ImagePicker();

  // 상태 변수
  String name = "";
  String introduction = "";
  String? imageUrl;
  String? email;
  File? imageFile;
  bool isLoading = false;
  bool isFormValid = false;
  var _deleteAccountResult = AsyncValue<void>.data(null);

  AsyncValue<void> get deleteAccountResult => _deleteAccountResult;

  // 컨트롤러
  TextEditingController nameController = TextEditingController();
  TextEditingController introController = TextEditingController();

  MyPageCorrectionViewModel({
    required UpdateUserProfileUseCase updateUserProfileUseCase,
    required UploadProfileImageUseCase uploadProfileImageUseCase,
    required GetUserDataUseCase getUserDataUseCase,
    required DeleteAccountUseCase deleteAccountUseCase,
  }): _updateUserProfileUseCase = updateUserProfileUseCase,
        _uploadProfileImageUseCase = uploadProfileImageUseCase,
        _getUserDataUseCase = getUserDataUseCase,
        _deleteAccountUseCase = deleteAccountUseCase;

  // 유저 데이터 초기화
  Future<void> initialize() async {
    isLoading = true;
    notifyListeners();

    try {
      final user = await _getUserDataUseCase.execute();
      name = user.name!;
      introduction = user.introduction!;
      imageUrl = user.imageUrl;
      email = user.email;
      nameController.text = name;
      introController.text = introduction;
    } catch (e) {
      // 에러 처리
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 닉네임 변경
  void setName(String value) {
    name = value;
    _validateForm();
    notifyListeners();
  }

  // 자기소개 변경
  void setIntro(String value) {
    introduction = value;
    _validateForm();
    notifyListeners();
  }

  // 이미지 선택
  Future<void> pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile!= null) {
      imageFile = File(pickedFile.path);
      await _uploadImage();
    }
  }

  // 이미지 업로드
  Future<void> _uploadImage() async {
    if (imageFile == null) return;
    isLoading = true;
    notifyListeners();

    try {
      final url = await _uploadProfileImageUseCase.execute(imageFile!);
      imageUrl = url;
    } catch (e) {
      // 에러 처리
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 유저 정보 저장
  void saveUserInfo(BuildContext context) async {
  try {
    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);

    await userDoc.update({
      'name': name,
      'intro': introduction,
      'imageUrl': imageUrl,
    });

    print("Firebase 업데이트 완료!");

    // 마이페이지로 이동
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyPage()),
    );
  } catch (e) {
    print("Firebase 업데이트 실패: $e");
  }
}
  // 폼 유효성 검사
  void _validateForm() {
    isFormValid = name.isNotEmpty && introduction.isNotEmpty;
  }

  bool get isChanged =>
      name!= nameController.text ||
      introduction!= introController.text ||
      imageFile!= null;

      // 회원 탈퇴 메서드
  Future<void> deleteAccount(BuildContext context) async {
  try {
    isLoading = true;
    notifyListeners();

    // 회원 탈퇴 UseCase 호출
    await _deleteAccountUseCase.execute();

    // 탈퇴 완료 후, Firebase Auth에서 로그아웃
    await FirebaseAuth.instance.signOut();

    // 로그아웃 후 로그인 페이지로 이동
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  } catch (e) {
    print("회원 탈퇴 실패: $e");
    // 실패 처리 (에러 메시지 등)
  } finally {
    isLoading = false;
    notifyListeners();
  }
  }
}