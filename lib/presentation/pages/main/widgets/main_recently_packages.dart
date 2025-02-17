import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_shadow.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/domain/entity/package.dart';
import 'package:wetravel/presentation/pages/guide_package_detail_page/package_detail_page.dart';
import 'package:wetravel/presentation/pages/main/widgets/main_label.dart';
import 'package:wetravel/presentation/provider/package_provider.dart';
import 'package:wetravel/presentation/provider/schedule_provider.dart';
import 'package:wetravel/presentation/widgets/package_item.dart';

class MainRecentlyPackages extends ConsumerWidget {
  /// 메인 페이지 최근에 본 패키지 영역
  final List<Package> recentPackages;
  const MainRecentlyPackages({super.key, required this.recentPackages});

  @override
  Widget build(BuildContext context, ref) {
    final getPackageUseCase = ref.read(getPackageUseCaseProvider);
    final getSchedulesUseCase = ref.read(getSchedulesUseCaseProvider);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          MainLabel(label: '최근에 본 패키지'),
          SizedBox(
            height: 120,
            child: recentPackages.isNotEmpty
                ? ListView.builder(
                    clipBehavior: Clip.none, // 자식 위젯이 잘리지 않게 함
                    scrollDirection: Axis.horizontal,
                    itemCount: recentPackages.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return PackageDetailPage(
                                    packageId: recentPackages[index].id,
                                    getPackageUseCase: getPackageUseCase,
                                    getSchedulesUseCase: getSchedulesUseCase,
                                  );
                                },
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow:
                                  AppShadow.generalShadow, // 각 항목에만 그림자 적용
                              borderRadius: AppBorderRadius.small12,
                              color: Colors.white, // 배경색 설정
                            ),
                            child: PackageItem(
                              title: recentPackages[index].title,
                              location: recentPackages[index].location,
                              guideImageUrl: recentPackages[index].userImageUrl,
                              packageImageUrl: recentPackages[index].imageUrl,
                              name: recentPackages[index].userName,
                              keywords:
                                  recentPackages[index].keywordList!.toList(),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text(
                      '최근에 본 패키지가 없어요',
                      style: AppTypography.body3,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
