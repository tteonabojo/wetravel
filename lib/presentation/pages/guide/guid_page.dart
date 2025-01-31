import 'package:flutter/material.dart';
import 'package:wetravel/constants/app_colors.dart';

class GuidePage extends StatelessWidget {
  final bool isGuide; // 가이드 여부

  const GuidePage({super.key, required this.isGuide});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grayScale_050,
      appBar: AppBar(
        backgroundColor: AppColors.grayScale_050,
      ),
      body: isGuide ? _buildGuideView() : _buildNonGuideView(context),
    );
  }

  // ✅ 가이드가 아닌 사용자가 볼 페이지
  Widget _buildNonGuideView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '가이드에 도전해보세요!\n내가 만든 일정 패키지로 누군가의 소중한 추억을 만들어주세요',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                  padding: WidgetStatePropertyAll(
                      EdgeInsets.symmetric(horizontal: 32, vertical: 12))),
              onPressed: () {},
              child: const Text('가이드 신청하기'),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ 가이드인 사용자가 볼 페이지 (내 패키지 리스트)
  Widget _buildGuideView() {
    final List<String> myPackages = [
      "파리 3박 4일 투어",
      "제주도 힐링 여행",
      "도쿄 먹방 여행"
    ]; // 내 패키지 예시 데이터

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '가이드님 환영합니다',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(), // 내부 스크롤 막음
            itemCount: myPackages.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(myPackages[index]),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // 패키지 상세 페이지 이동
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
