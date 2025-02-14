import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/domain/entity/user.dart';
import 'package:wetravel/presentation/pages/Notice_Page/notice_add_page.dart';
import 'package:wetravel/presentation/pages/Notice_Page/notice_edit_page.dart';

class NoticePage extends StatefulWidget {
  final dynamic userData;

  const NoticePage({Key? key, required this.userData}) : super(key: key);

  @override
  _NoticePageState createState() => _NoticePageState();
}

class _NoticePageState extends State<NoticePage> {
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    setState(() {
      isAdmin = widget.userData?['isAdmin'] ?? true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('공지사항'),
      ),
      body: Padding( // Padding 추가
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
            SizedBox(height: 4),
            Expanded( // Expanded 추가
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('notices').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return ListView(
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
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
                                    data['title'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    data['date'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isAdmin)
                              PopupMenuButton<String>(
                                color: AppColors.grayScale_050,
                                icon: SvgPicture.asset(
                                  'assets/icons/ellipsis_vertical.svg',
                                  width: 20,
                                  height: 20,
                                ),
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NoticeEditPage(
                                            noticeData: data, noticeId: document.id),
                                      ),
                                    );
                                  } else if (value == 'delete') {
                                    FirebaseFirestore.instance
                                        .collection('noticesCollection')
                                        .doc(document.id)
                                        .delete();
                                  }
                                },
                                itemBuilder: (BuildContext context) {
                                  return [
                                    PopupMenuItem<String>(
                                      value: 'edit',
                                      padding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 8),
                                      child: Center(
                                        child: Text('수정'),
                                      ),
                                    ),
                                    PopupMenuItem<String>(
                                      value: 'delete',
                                      padding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 8),
                                      child: Center(
                                        child: Text(
                                          '삭제',
                                          style: TextStyle(
                                            color: Colors.redAccent,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ];
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                                constraints: BoxConstraints(minWidth: 60),
                              ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              backgroundColor: AppColors.primary_450,
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NoticeAddPage(),
                  ),
                );
              },
              child: Icon(Icons.add, color: Colors.white),
              elevation: 0,
            )
          : null,
    );
  }
}