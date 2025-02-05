import 'package:flutter/material.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/domain/entity/package.dart';
import 'package:wetravel/presentation/pages/main/widgets/main_label.dart';
import 'package:wetravel/presentation/widgets/package_item.dart';

class MainRecentlyPackages extends StatelessWidget {
  /// 메인 페이지 최근에 본 패키지 영역
  final List<Package> recentPackages;
  const MainRecentlyPackages({super.key, required this.recentPackages});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 168,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          MainLabel(label: '최근에 본 패키지'),
          SizedBox(
            height: 120,
            child: recentPackages.isNotEmpty
                ? ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: recentPackages.length,
                    itemBuilder: (BuildContext context, int index) {
                      return PackageItem(
                        title: recentPackages[index].title,
                        location: recentPackages[index].location,
                        guideImageUrl: recentPackages[index].userImageUrl,
                        packageImageUrl: recentPackages[index].imageUrl,
                        name: recentPackages[index].userName,
                        keywords: recentPackages[index].keywordList!.toList(),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(width: 20);
                    },
                  )
                : Center(
                    child: Text(
                    '최근에 본 패키지가 없어요',
                    style: AppTypography.body3,
                  )),
          ),
        ],
      ),
    );
  }
}
