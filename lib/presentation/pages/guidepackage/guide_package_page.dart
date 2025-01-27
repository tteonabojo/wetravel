import 'package:flutter/material.dart';

class GuidePackagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              _buildAppBar(context), // 커스텀 AppBar
              _buildFilters(), // 필터
              Expanded(
                child: ListView(
                  children: [
                    // 패키지 카드 출력
                    _buildPackageCard({
                      'title': '원숭이들이 있는 온천 여행',
                      'subtitle': '2박 3일 · 혼자 · 액티비티',
                      'location': '도쿄',
                      'author': '나는 이구역짱',
                      'keywords': '도쿄 · 혼자 · 액티비티',  // 키워드
                    }),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _buildAppBar(BuildContext context) {
  return Stack(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),  // AppBar의 패딩을 줄여서 간격 최소화
        color: Colors.white, // AppBar 배경색
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context); // 뒤로가기 동작
                  },
                ),
                SizedBox(width: 16),  // 뒤로가기 버튼과 제목 사이 간격
                Spacer(),
              ],
            ),
            SizedBox(height: 8),  // 제목과 뒤로가기 버튼 사이 간격 줄임
            Text(
              "맞춤 가이드 일정 추천", // 제목
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),  // 제목과 부제목 사이 간격 줄임
            Text(
              "최적의 가이드 일정을 담아 보세요", // 부제목
              style: TextStyle(
                color: Colors.grey,  // 부제목 색상
                fontSize: 16,  // 부제목 폰트 크기
              ),
            ),
            SizedBox(height: 0),
          ],
        ),
      ),
    ],
  );
}

Widget _buildFilters() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    color: Colors.white, // 필터 배경 색
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip("도쿄"),
          _buildFilterChip("혼자"),
          _buildFilterChip("2박 3일"),
          _buildFilterChip("액티비티"),
          _buildFilterChip("게스트 하우스"),
        ],
      ),
    ),
  );
}

Widget _buildFilterChip(String label) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0),
    child: Chip(
      label: Text(label),
      backgroundColor: Colors.grey[300],  // 필터 배경 색을 회색으로 설정
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),  // 모서리 R값을 더 크게 설정
      ),
    ),
  );
}

Widget _buildPackageCard(Map<String, String> package) {
  return Column(
    children: [
      // 카드 위에 순서 정렬 아이콘 추가
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: Icon(Icons.sort, color: Colors.black),
            onPressed: () {
              // 정렬 동작 추가 (필요에 따라 구현)
            },
          ),
        ],
      ),
      // 패키지 카드
      Card(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),  // 카드 상하 마진을 줄임
        child: ListTile(
          contentPadding: const EdgeInsets.all(16.0),  // ListTile 내부 패딩을 늘려서 크기 키우기
          leading: SizedBox(
            width: 120,  // 이미지 크기 키우기
            height: 120,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                'https://picsum.photos/100',
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(
            package['title']!,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),  // 제목 크기 키우기
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 키워드만 텍스트로 표시
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  (package['keywords'] is String)
                      ? package['keywords']!  // 문자열일 경우 바로 표시
                      : '키워드 없음',  // 키워드가 없거나 잘못된 형식일 경우
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
              // "도쿄"와 "나는 이구역짱" 표시
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.red),  // 위치 아이콘
                  SizedBox(width: 8),  // 아이콘과 텍스트 간 간격
                  Text(
                    package['location']!,  // "도쿄" 부분
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,  // 프로필 이미지 크기
                    backgroundImage: NetworkImage('https://picsum.photos/50'),  // 프로필 이미지 URL
                  ),
                  SizedBox(width: 8),  // 프로필 이미지와 텍스트 간 간격
                  Text(
                    package['author']!,  // "나는 이구역짱" 부분
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false, // 디버그 배너 제거
    home: GuidePackagePage(),
  ));
}
