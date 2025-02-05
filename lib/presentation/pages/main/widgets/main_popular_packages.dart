import 'package:flutter/material.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/domain/entity/package.dart';
import 'package:wetravel/presentation/pages/main/widgets/main_label.dart';
import 'package:wetravel/presentation/widgets/package_item.dart';

class MainPopularPackages extends StatelessWidget {
  /// 메인 페이지 인기 패키지 영역
  final List<Package> popularPackages;
  const MainPopularPackages({super.key, required this.popularPackages});

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
              child: popularPackages.isNotEmpty
                  ? ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemCount: popularPackages.length,
                      itemBuilder: (BuildContext context, int index) {
                        int? rate =
                            index <= 2 ? index + 1 : null; // 3등 까지 순위 표시
                        return SizedBox(
                          child: PackageItem(
                            rate: rate,
                            title: popularPackages[index].title,
                            location: popularPackages[index].location,
                            guideImageUrl: popularPackages[index].userImageUrl,
                            packageImageUrl: popularPackages[index].imageUrl,
                            name: popularPackages[index].userName,
                            keywords:
                                popularPackages[index].keywordList!.toList(),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 8);
                      },
                    )
                  : Center(
                      child: Text(
                        '인기있는 패키지가 없어요',
                        style: AppTypography.body3,
                      ),
                    ))
        ],
      ),
    );
  }
}
