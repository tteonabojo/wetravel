import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_icons.dart';
import 'package:wetravel/core/constants/app_shadow.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/core/constants/firestore_constants.dart';
import 'package:wetravel/presentation/pages/admin/admin_page.dart';
import 'package:wetravel/presentation/pages/my_page_correction/mypage_correction.dart';
import 'package:wetravel/presentation/pages/notice_page/noticepage.dart';
import 'package:wetravel/presentation/provider/user_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MyPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userStreamProvider);

    return Scaffold(
      body: userAsync.when(
        data: (userData) {
          final bool isAdmin = userData?['isAdmin'] ?? false; // isAdmin 값 가져오기

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                _buildProfileBox(context, ref),
                if (userData?['isAdmin'] ?? false)
                  Column(
                     children: [
                       SizedBox(height: 8),
                       _buildAdminBox(context),
                     ],
                   ),
//                SizedBox(height: 8),
//                _buildNoticeBox(context, isAdmin), // isAdmin 값 전달
                SizedBox(height: 8),
                _buildInquiryBox(context),
                SizedBox(height: 8),
                _buildTermsAndPrivacyBox(),
                SizedBox(height: 8),
                _buildLogoutBox(context, ref),
                SizedBox(height: 8),
                _buildDeleteAccount(context, ref),
              ],
            ),
          );
        },
        loading: () => Center(child: CircularProgressIndicator(color: AppColors.primary_450,)), // 로딩 중 UI
        error: (error, stack) => Center(child: Text("오류 발생: $error")), // 에러 처리
      ),
    );
  }
}

Widget _buildAdminBox(context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return AdminPage();
        },
      ));
    },
    child: Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppBorderRadius.small12,
        boxShadow: AppShadow.generalShadow,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          '관리자 메뉴 : 패키지 관리',
          style: AppTypography.buttonLabelSmall
              .copyWith(color: AppColors.grayScale_750),
        ),
      ),
    ),
  );
}

// Widget _buildNoticeBox(BuildContext context, bool isAdmin) {
//  return GestureDetector(
 //   onTap: () {
//      var userData;
//      Navigator.push(
//        context,
//        MaterialPageRoute(
//          builder: (context) => NoticePage(userData: userData), //isAdmin 값 전달
//        ),
//      );
//    },
//    child: Container(
//      height: 56,
//      padding: const EdgeInsets.symmetric(horizontal: 16),
//      decoration: BoxDecoration(
//        color: Colors.white,
//        borderRadius: BorderRadius.circular(12),
//        boxShadow: AppShadow.generalShadow,
//      ),
//      child: Align(
//        alignment: Alignment.centerLeft,
//        child: Text(
//          '공지사항',
//          style: AppTypography.body2.copyWith(color: AppColors.grayScale_750),
//        ),
//      ),
//    ),
//  );
//}

Widget _buildProfileBox(BuildContext context, WidgetRef ref) {
  final userAsync = ref.watch(userStreamProvider); // Firestore 실시간 데이터 사용

  return userAsync.when(
    data: (userData) {
      if (userData == null) {
        return Text('사용자 데이터를 불러올 수 없습니다.');
      }

      // 닉네임 기본값 설정
      final uid = userData['uid'] ?? '';
      final defaultNickname =
          uid.isNotEmpty ? "AppleUser_${uid.substring(0, 6)}" : "사용자";
      final name = userData['name']?.isNotEmpty == true
          ? userData['name']
          : defaultNickname;

      final email = userData['email'] ?? '이메일 없음';
      final imageUrl = userData['imageUrl']; // Firestore에서 가져온 프로필 이미지 URL
      final validUrl = '$imageUrl'.startsWith('http');

      // isAdmin 값 가져오기 (true든 false든 무조건 표시)
      final bool isAdmin = userData['isAdmin'] ?? false;

      return Container(
        height: 89,
        padding: const EdgeInsets.symmetric(vertical: 16.5, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppBorderRadius.small12,
          boxShadow: AppShadow.generalShadow,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundImage: validUrl ? NetworkImage(imageUrl) : null,
              child: validUrl ? null : SvgPicture.asset(AppIcons.userRound),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (isAdmin) //이름 바로 옆에 "관리자" 태그 추가
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary_450,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '관리자',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  (email.length > 25) ? '${email.substring(0, 20)}...' : email,
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
                AppIcons.pen,
                width: 20,
                height: 20,
              ),
            ),
          ],
        ),
      );
    },
    loading: () => const Center(
      child: CircularProgressIndicator(
        color: AppColors.primary_450,
      ),
    ),
    error: (err, stack) => Text('오류 발생: $err'),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppShadow.generalShadow,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          '문의하기',
          style: AppTypography.body2.copyWith(color: AppColors.grayScale_750),
        ),
      ),
    ),
  );
}

void _showInquiryDialog(BuildContext context) {
  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text(
          '문의하기',
          style: AppTypography.body2.copyWith(color: AppColors.grayScale_750),
        ),
        content: Text('관리자 이메일: ksh20531@gmail.com'),
        actions: [
          CupertinoDialogAction(
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

Widget _buildTermsAndPrivacyBox() {
  return GestureDetector(
    onTap: () async {
      final url =
          'https://weetravel.notion.site/188e73dd935881a8af01f4f12db0d7c9';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    },
    child: _buildBoxWithText('이용약관/개인정보 처리방침'),
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
        style: AppTypography.body2.copyWith(color: AppColors.grayScale_750),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppShadow.generalShadow,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          '로그아웃',
          style: AppTypography.body2.copyWith(color: AppColors.grayScale_750),
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
  showCupertinoDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return CupertinoAlertDialog(
        title: const Text('회원탈퇴'),
        content: const Text('탈퇴 확인을 위해 재인증이 필요합니다.\n이 작업은 되돌릴 수 없습니다.'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(dialogContext).pop(), // 다이얼로그 닫기
            child: const Text('취소'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true, // 빨간색 강조
            onPressed: () async {
              //  Navigator.of(dialogContext).pop(); // 다이얼로그 닫기
              onDeleteAccountPressed(context, ref);
            },
            child: const Text('탈퇴'),
          ),
        ],
      );
    },
  );
}

Future<void> deleteUserAccount(BuildContext context, WidgetRef ref) async {
  final firestoreConstants = FirestoreConstants();
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    print("로그인이 필요합니다.");
    return;
  }

  try {
    await _reauthenticateUser(user);

    final userDoc = await FirebaseFirestore.instance
        .collection(firestoreConstants.usersCollection)
        .doc(user.uid)
        .get();
    final profileImageUrl = userDoc.data()?['profileImageUrl'] as String? ?? '';

    await FirebaseFirestore.instance
        .collection(firestoreConstants.usersCollection)
        .doc(user.uid)
        .delete();
    print("Firestore 사용자 데이터 삭제 완료");

    if (profileImageUrl.isNotEmpty) {
      try {
        final ref = FirebaseStorage.instance.refFromURL(profileImageUrl);
        await ref.delete();
        print("프로필 이미지 삭제 완료");
      } catch (e) {
        print("프로필 이미지 삭제 실패: $e");
      }
    }

    // 상태 초기화
    print('캐시삭제');
    ref.invalidate(signOutUsecaseProvider); // 로그아웃 상태 초기화
    print('캐시삭제');
    ref.invalidate(userRepositoryProvider); // 사용자 관련 상태 초기화
    print('캐시삭제');
    ref.invalidate(signInWithProviderUsecaseProvider);
    print('캐시삭제');
    ref.invalidate(userStreamProvider);

    await user.delete();
    print(" 사용자 계정 삭제 완료");

    await ref.read(signOutUsecaseProvider).signOut();
    print(" 로그아웃 완료");
  } catch (e) {
    print("회원 탈퇴 실패: $e");
  }
}

void onDeleteAccountPressed(BuildContext context, WidgetRef ref) async {
  await deleteUserAccount(context, ref);

  if (context.mounted) {
    print("회원 탈퇴 후 로그인 페이지로 이동 실행됨"); // 확인용 디버깅
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  } else {
    print("context가 dispose됨"); // 확인용 디버깅
  }
}

// Google & Apple 로그인 사용자 재인증 함수
Future<void> _reauthenticateUser(User user) async {
  try {
    // 현재 사용자의 인증 제공 방식 확인
    final providerData = user.providerData;
    if (providerData.isEmpty) return;

    final providerId = providerData.first.providerId;

    if (providerId == 'google.com') {
      // Google 로그인 사용자 재인증
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();
      await user.reauthenticateWithProvider(googleProvider);
    } else if (providerId == 'apple.com') {
      // Apple 로그인 사용자 재인증
      final OAuthProvider appleProvider = OAuthProvider('apple.com');
      await user.reauthenticateWithProvider(appleProvider);
    }
  } catch (e) {
    print("재인증 실패: $e");
    throw FirebaseAuthException(
        code: 'reauthentication-failed', message: "재인증에 실패했습니다.");
  }
}
