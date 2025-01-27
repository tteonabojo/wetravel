import 'package:flutter/material.dart';
import 'widgets/app_bar.dart';
import 'widgets/filters.dart';
import 'widgets/package_card.dart';

class GuidePackagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          GuideAppBar(), // 앱바
          GuideFilters(), // 필터 섹션
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
                PackageCard(
                  title: '원숭이들이 있는 온천 여행',
                  subtitle: '2박 3일 · 혼자 · 액티비티',
                  location: '도쿄',
                  author: '나는 이구역짱',
                  keywords: ['도쿄 | 혼자 | 액티비티'],
                ),
                PackageCard(
                  title: '해변에서 휴식 여행',
                  subtitle: '3박 4일 · 친구들 · 해양 스포츠',
                  location: '오키나와',
                  author: '여행 전문가',
                  keywords: ['해변 | 친구들 | 해양 스포츠'],
                ),
                PackageCard(
                  title: '남자들의 우정 여행',
                  subtitle: '1박 2일 · 친구들 · 군대체험',
                  location: '북한',
                  author: '탈북 전문가',
                  keywords: ['해변 | 친구들 | 군대체험'],
                ),
                PackageCard(
                  title: '에메랄드 빛 바다 여행',
                  subtitle: '4박 5일 · 연인 · 데이트',
                  location: '세부',
                  author: '웨딩플래너',
                  keywords: ['해변 | 연 | 데이트'],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}