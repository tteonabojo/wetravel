import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/domain/entity/package.dart';
import 'package:wetravel/presentation/pages/guidepackagedetailpage/package_detail_page.dart';
import 'package:wetravel/presentation/pages/main/widgets/main_label.dart';
import 'package:wetravel/presentation/provider/package_provider.dart';
import 'package:wetravel/presentation/provider/schedule_provider.dart';
import 'package:wetravel/presentation/widgets/package_item.dart';

class MainPopularPackages extends ConsumerWidget {
  /// 메인 페이지 인기 패키지 영역
  final List<Package> popularPackages;

  const MainPopularPackages({super.key, required this.popularPackages});

  @override
  Widget build(BuildContext context, ref) {
    final getPackageUseCase = ref.read(getPackageUseCaseProvider);
    final getSchedulesUseCase = ref.read(getSchedulesUseCaseProvider);

    // isHidden이 false인 패키지만 필터링
    final visiblePackages =
        popularPackages.where((package) => package.isHidden == false).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: MainLabel(label: '인기 있는 패키지'),
        ),
        visiblePackages.isNotEmpty
            ? Column(
                spacing: 8,
                children: List.generate(
                  visiblePackages.length,
                  (index) {
                    int? rate = index <= 2 ? index + 1 : null; // 3등 까지 순위 표시
                    return GestureDetector(
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return PackageDetailPage(
                                packageId: visiblePackages[index].id,
                                getPackageUseCase: getPackageUseCase,
                                getSchedulesUseCase: getSchedulesUseCase,
                              );
                            },
                          ),
                        );
                      },
                      child: PackageItem(
                        rate: rate,
                        title: visiblePackages[index].title,
                        location: visiblePackages[index].location,
                        guideImageUrl: visiblePackages[index].userImageUrl,
                        packageImageUrl: visiblePackages[index].imageUrl,
                        name: visiblePackages[index].userName,
                        keywords: visiblePackages[index].keywordList!.toList(),
                      ),
                    );
                  },
                ),
              )
            : Center(
                child: Text(
                  '인기있는 패키지가 없어요',
                  style: AppTypography.body3,
                ),
              ),
        SizedBox(height: 16)
      ],
    );
  }
}
