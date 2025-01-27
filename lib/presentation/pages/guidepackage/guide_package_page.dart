import 'package:flutter/material.dart';

class GuidePackagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildAppBar(context), // 앱바
          _buildFilters(), // 필터 섹션
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 8.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[200],
                child: IconButton(
                  icon: Icon(Icons.sort, color: Colors.black),
                  onPressed: () {
                    // 정렬 버튼 동작 추가
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              children: [
                _buildPackageCard({
                  'title': '원숭이들이 있는 온천 여행',
                  'subtitle': '2박 3일 · 혼자 · 액티비티',
                  'location': '도쿄',
                  'author': '나는 이구역짱',
                  'keywords': ['도쿄 | 혼자 | 액티비티'],
                }),
                _buildPackageCard({
                  'title': '해변에서 휴식 여행',
                  'subtitle': '3박 4일 · 친구들 · 해양 스포츠',
                  'location': '오키나와',
                  'author': '여행 전문가',
                  'keywords': ['해변 | 친구들 | 해양 스포츠'],
                }),
                _buildPackageCard({
                  'title': '해변에서 휴식 여행',
                  'subtitle': '3박 4일 · 친구들 · 해양 스포츠',
                  'location': '오키나와',
                  'author': '여행 전문가',
                  'keywords': ['해변 | 친구들 | 해양 스포츠'],
                }),
                _buildPackageCard({
                  'title': '해변에서 휴식 여행',
                  'subtitle': '3박 4일 · 친구들 · 해양 스포츠',
                  'location': '오키나와',
                  'author': '여행 전문가',
                  'keywords': ['해변 | 친구들 | 해양 스포츠'],
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildAppBar(BuildContext context) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
    color: Colors.white,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Spacer(),
          ],
        ),
        SizedBox(height: 8),
        Text(
          "맞춤 가이드 일정 추천",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          "최적의 가이드 일정을 담아 보세요",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16),
        ),
      ],
    ),
  );
}

Widget _buildFilters() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    color: Colors.white,
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
      backgroundColor: Colors.grey[300],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}

Widget _buildPackageCard(Map<String, dynamic> package) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
    child: Card(
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: SizedBox(
          width: 90,
          height: 90,
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
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                (package['keywords'] is List<String>)
                    ? (package['keywords'] as List<String>).join(' · ')
                    : '키워드 없음',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.red),
                SizedBox(width: 8),
                Text(
                  package['location']!,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage('https://picsum.photos/50'),
                ),
                SizedBox(width: 8),
                Text(
                  package['author']!,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: GuidePackagePage(),
  ));
}
