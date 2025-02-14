import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/core/constants/app_colors.dart';

class NoticePage extends StatefulWidget {
  @override
  _NoticePageState createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    _fetchAdminStatus();
  }

  // ✅ Firestore에서 현재 로그인한 사용자의 isAdmin 값 가져오기
  Future<void> _fetchAdminStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      setState(() {
        isAdmin = userDoc.data()?['isAdmin'] ?? false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('공지사항'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 20),
        child: Column(
          children: [
            Container(
              height: 44,
              color: AppColors.grayScale_050,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '새로운 기능 및 개선 사항을 알려드려요',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.grayScale_450,
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 3, // 예시 아이템 개수
                itemBuilder: (context, index) {
                  return Container(
                    height: 100,
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '공지사항 제목 ${index + 1}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.grayScale_950,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '2025. 02. 14',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.grayScale_950,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isAdmin)
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: AppColors.primary_450),
                                onPressed: () {
                                  // 수정 기능 추가
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  // 삭제 기능 추가
                                },
                              ),
                            ],
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              backgroundColor: AppColors.grayScale_950,
              onPressed: () {
                // 공지사항 추가 기능 추가
              },
              child: Icon(Icons.add, color: Colors.white),
            )
          : null, // ✅ 일반 유저면 버튼 안 보이게 처리
    );
  }
}
