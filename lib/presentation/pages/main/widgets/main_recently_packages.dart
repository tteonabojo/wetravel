import 'package:flutter/material.dart';
import 'package:wetravel/presentation/pages/main/widgets/main_label.dart';
import 'package:wetravel/presentation/widgets/package_item.dart';

class MainRecentlyPackages extends StatelessWidget {
  /// 메인 페이지 최근에 본 패키지 영역
  const MainRecentlyPackages({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 168,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          MainLabel(label: '최근에 본 일정 패키지'),
          SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                PackageItem(
                  title: '원숭이들이 있는 온천 여행',
                  location: '도쿄',
                  guideImageUrl: '',
                  name: '나는 이구역짱',
                  keywords: ['2박 3일', '혼자', '액티비티'],
                  packageImageUrl: '',
                ),
                SizedBox(width: 20),
                PackageItem(
                  title: '원숭이들이 있는 온천 여행',
                  location: '도쿄',
                  guideImageUrl: '',
                  name: '나는 이구역짱',
                  keywords: ['2박 3일', '혼자', '액티비티'],
                  packageImageUrl: '',
                ),
                SizedBox(width: 20),
                PackageItem(
                  title: '원숭이들이 있는 온천 여행',
                  location: '도쿄',
                  guideImageUrl: '',
                  name: '나는 이구역짱',
                  keywords: ['2박 3일', '혼자', '액티비티'],
                  packageImageUrl: '',
                ),
                SizedBox(width: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
