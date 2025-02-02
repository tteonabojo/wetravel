import 'package:flutter/material.dart';

class GuideProfilePage extends StatelessWidget {
  final String author;

  const GuideProfilePage({Key? key, required this.author}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16), // 좌우 여백 16 유지
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage('https://picsum.photos/100'),
            ),
            const SizedBox(height: 12),
            Text(
              author,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20), // 닉네임과 "자기소개" 사이 간격 20 추가
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '자기소개',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity, // 가득 차게 설정
              height: 80,
              padding: const EdgeInsets.all(16), // 내부 패딩 추가
              decoration: BoxDecoration(
                color: Colors.white, // 배경색 추가
                borderRadius: BorderRadius.circular(12), // 모서리 R 값 12
              ),
              child: Text(
                '이곳에 자기소개 내용을 입력합니다.',
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 20), // 자기소개 박스와 여행 일정 사이 여백 20 추가
            Align(
              alignment: Alignment.centerLeft, // 왼쪽 정렬
              child: Text(
                '등록한 여행 일정',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // 폰트 크기 18
              ),
            ),
            const SizedBox(height: 12), // 리스트 추가될 공간 미리 확보
          ],
        ),
      ),
    );
  }
}
