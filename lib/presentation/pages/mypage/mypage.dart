import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wetravel/core/constants/app_shadow.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/presentation/pages/mypagecorrection/mypage_correction.dart';
import 'package:wetravel/presentation/provider/user_provider.dart';

class MyPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '마이페이지',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            _buildProfileBox(context, ref), // 프로필 정보 표시
            SizedBox(height: 8),
            _buildInquiryBox(context),
            SizedBox(height: 8),
            _buildBoxWithText('이용약관/개인정보 처리방침'),
            SizedBox(height: 8),
            _buildLogoutBox(context, ref),
            SizedBox(height: 8),
            _buildDeleteAccount(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileBox(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider); // userProvider를 사용하여 사용자 정보 가져오기

    return userAsync.when(
      data: (user) {
        return Container(
          height: 89,
          padding: const EdgeInsets.symmetric(vertical: 16.5, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: user.imageUrl != null
                    ? NetworkImage(user.imageUrl!)
                    : const AssetImage('assets/images/sample_profile.jpg')
                        as ImageProvider, // 기본 이미지 추가
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    user.displayName ?? '샘플 닉네임', // 이름 정보 표시, 없으면 '이름 없음' 표시
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    user.email ?? '이메일 없음', // 이메일 정보 표시, 없으면 '이메일 없음' 표시
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              Spacer(),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyPageCorrection()),
                  );
                },
                icon: SvgPicture.asset(
                  'assets/icons/pen.svg',
                  width: 24,
                  height: 24,
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const CircularProgressIndicator(), // 로딩 중 표시
      error: (err, stack) => Text('Error: $err'), // 에러 발생 시 표시
    );
  }

  Widget _buildInquiryBox(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showInquiryDialog(context);
      },
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '문의하기',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  void _showInquiryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('문의하기'),
          content: Text('관리자 이메일: admin@example.com'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBoxWithText(String text) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppShadow.generalShadow,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutBox(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        final signOutUsecase = ref.read(signOutUsecaseProvider);
        await signOutUsecase.signOut();

        // 로그아웃 후 로그인 페이지로 이동 (예: LoginPage())
        Navigator.pushReplacementNamed(context, '/login');
      },
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '로그아웃',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteAccount(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: GestureDetector(
        onTap: () {
          _showDeleteAccountDialog(context, ref);
        },
        child: Text(
          '회원탈퇴',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('회원탈퇴'),
          content: Text('정말로 회원 탈퇴를 진행하시겠습니까? 이 작업은 되돌릴 수 없습니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // 다이얼로그 닫기
                await deleteUserAccount(context, ref);
              },
              child: Text(
                '탈퇴',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteUserAccount(BuildContext context, WidgetRef ref) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("사용자가 존재하지 않습니다.");
    }

    // Firestore에서 사용자 데이터 삭제
    await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();

    // 애플 로그인 사용자의 경우 reauthentication 필요 가능성 있음.
    final signInMethods =
        // ignore: deprecated_member_use
        await FirebaseAuth.instance.fetchSignInMethodsForEmail(user.email!);

    if (signInMethods.contains('apple.com')) {
      // 애플 로그인 사용자의 경우
      final appleProvider = OAuthProvider("apple.com");
      final credential = await user.reauthenticateWithProvider(appleProvider);
      await credential.user?.delete(); // 재인증 후 삭제
    } else {
      // 일반 로그인 사용자는 그냥 삭제
      await user.delete();
    }

    // 로그아웃 후 로그인 페이지로 이동
    await ref.read(signOutUsecaseProvider).signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }
}
