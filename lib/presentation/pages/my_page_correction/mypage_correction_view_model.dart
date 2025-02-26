import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/domain/usecase/update_user_profile_usecase.dart';
import 'package:wetravel/domain/usecase/upload_profile_image_usecase.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wetravel/domain/usecase/user/delete_account_usecase.dart';
import 'package:wetravel/presentation/pages/login/login_page.dart';
import 'package:wetravel/presentation/pages/my_page/my_page.dart';
import 'package:wetravel/core/constants/firestore_constants.dart';
import 'package:image/image.dart' as img;

class MyPageCorrectionViewModel extends ChangeNotifier {
  final UpdateUserProfileUseCase _updateUserProfileUseCase;
  final UploadProfileImageUseCase _uploadProfileImageUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;
  final ImagePicker _picker = ImagePicker();
  final FirestoreConstants firestoreConstants = FirestoreConstants();

  // 상태 변수
  String _name = ""; // 닉네임 저장
  String _intro = ""; // 자기소개 저장
  String? _imageUrl; // 프로필 이미지 URL
  File? _imageFile; // 로컬에서 선택한 이미지 파일
  String? userEmail; // 이메일 저장
  String? _tempImagePath; // 임시 이미지 파일 경로
  bool isUploading = false; // 업로드 중 여부 확인
  bool isNameValid = false; // 닉네임 유효성
  bool isIntroValid = false; // 자기소개 유효성

  String? get imageUrl => _imageUrl;
  String get name => _name;
  bool get isFormValid => _name.isNotEmpty && _intro.isNotEmpty;
  bool get isChanged =>
    name != nameController.text ||
    _intro != introController.text ||
    _tempImageFile != null;
  File? _tempImageFile;
  File? get tempImageFile => _tempImageFile;

  // 컨트롤러
  TextEditingController nameController = TextEditingController();
  TextEditingController introController = TextEditingController();

  MyPageCorrectionViewModel({
    required UpdateUserProfileUseCase updateUserProfileUseCase,
    required UploadProfileImageUseCase uploadProfileImageUseCase,
    required DeleteAccountUseCase deleteAccountUseCase,
  }): _updateUserProfileUseCase = updateUserProfileUseCase,
        _uploadProfileImageUseCase = uploadProfileImageUseCase,
        _deleteAccountUseCase = deleteAccountUseCase;

  // Firestore에서 사용자 데이터 가져오기
  Future<void> fetchUserData() async {
    isUploading = true;
    notifyListeners();

    try {
      final userDoc = await FirebaseFirestore.instance
        .collection(firestoreConstants.usersCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

      if (userDoc.exists) {
        final userData = userDoc.data();
        _name = userData?['name']?? "";
        _intro = userData?['intro']?? "";
        _imageUrl = userData?['imageUrl'];
        userEmail = userData?['email'];

        nameController.text = _name;
        introController.text = _intro;
        isNameValid = _name.isNotEmpty; // 닉네임 유효성 초기화
        isIntroValid = _intro.isNotEmpty; // 자기소개 유효성 초기화
      } else {
        print("사용자 데이터 없음");
      }
    } catch (e) {
      print("Firestore에서 사용자 데이터 가져오기 실패: $e");
    } finally {
      isUploading = false;
      notifyListeners();
    }
  }

  // 초기화 시 Firestore 데이터 불러오기
  Future<void> initialize() async {
    await fetchUserData();
  }

  // 닉네임 변경
  void setName(String name) {
  this._name = name;
  notifyListeners();
}

  // 자기소개 변경
  void setIntro(String intro) {
  this._intro = intro;
  notifyListeners();
}

  void setImageUrl(String url) {
    _imageUrl = url;
    notifyListeners();
  }

  // 이미지 선택
Future<void> pickImage() async {
  final XFile? pickedFile = await _picker.pickImage(
    source: ImageSource.gallery,
    requestFullMetadata: false, // 메타데이터 방지
  );
  if (pickedFile != null) {
    _tempImageFile = File(pickedFile.path);
    _tempImagePath = pickedFile.path;
    notifyListeners();
  }
}

// 유저 정보 저장 (등록 버튼 클릭 시 호출)
Future<void> saveUserInfo(BuildContext context) async {
  try {
    if (_tempImagePath != null) {
      await _uploadImage();
    }

    final userDoc = FirebaseFirestore.instance
        .collection(firestoreConstants.usersCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid);

    await userDoc.set({
      'name': _name,
      'intro': _intro,
      'imageUrl': _imageUrl,
    }, SetOptions(merge: true));

    print("Firebase 업데이트 완료!");
    Navigator.pop(context);
  } catch (e) {
    print("Firebase 업데이트 실패: $e");
  }
}

// 이미지 업로드 (saveUserInfo에서 호출)
Future<void> _uploadImage() async {
  if (_tempImageFile == null) return;
  isUploading = true;
  notifyListeners();

  try {
    File imageFile = _tempImageFile!;

    // 이미지 파일 읽기
    Uint8List imageBytes = await imageFile.readAsBytes();
    img.Image? originalImage = img.decodeImage(imageBytes);

    if (originalImage == null) {
      throw Exception("이미지 디코딩 실패");
    }

    // 이미지 리사이징
    img.Image resizedImage = img.copyResize(
      originalImage,
      width: 400,
      height: 400,
    );

    // 리사이징된 이미지 파일로 저장 (임시 파일)
    File resizedFile = File('${_tempImagePath!}_resized.jpg');
    await resizedFile.writeAsBytes(img.encodeJpg(resizedImage));

    // 리사이징된 이미지 파일 업로드
    final url = await _uploadProfileImageUseCase.execute(resizedFile);
    _imageUrl = url;

    // 임시 파일 삭제
    await imageFile.delete();
    await resizedFile.delete();
    _tempImagePath = null; // 경로 초기화
  } catch (e) {
    print("이미지 업로드 실패: $e");
  } finally {
    isUploading = false;
    notifyListeners();
  }
}

  // 회원 탈퇴 메서드
  Future<void> deleteAccount(BuildContext context) async {
    try {
      isUploading = true;
      notifyListeners();

      // 회원 탈퇴 UseCase 호출
      await _deleteAccountUseCase.execute();

      // 탈퇴 완료 후, Firebase Auth에서 로그아웃
      await FirebaseAuth.instance.signOut();

      // 로그아웃 후 로그인 페이지로 이동
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
            (route) => false,
      );
    } catch (e) {
      print("회원 탈퇴 실패: $e");
      // 실패 처리 (에러 메시지 등)
    } finally {
      isUploading = false;
      notifyListeners();
    }
  }
}