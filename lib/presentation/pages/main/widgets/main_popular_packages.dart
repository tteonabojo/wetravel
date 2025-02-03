import 'package:flutter/material.dart';
import 'package:wetravel/presentation/pages/main/widgets/main_label.dart';
import 'package:wetravel/presentation/widgets/package_item.dart';

class MainPopularPackages extends StatelessWidget {
  /// 메인 페이지 인기 패키지 영역
  const MainPopularPackages({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: MainLabel(label: '인기 있는 패키지'),
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                int? rate = index <= 2 ? index + 1 : null; // 3등 까지 순위 표시
                return PackageItem(
                  rate: rate,
                  title: '원숭이들이 있는 온천 여행',
                  location: '도쿄',
                  guideImageUrl: '',
                  name: '나는 이구역짱',
                  keywords: ['2박 3일', '혼자', '액티비티'],
                  packageImageUrl: '',
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: 8);
              },
            ),
          )
        ],
      ),
    );
  }
}
