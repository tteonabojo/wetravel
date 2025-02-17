import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_shadow.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/presentation/pages/guide_package_detail_page/package_detail_page.dart';
import 'package:wetravel/presentation/pages/main/main_page_view_model.dart';
import 'package:wetravel/presentation/pages/main/widgets/main_label.dart';
import 'package:wetravel/presentation/provider/package_provider.dart';
import 'package:wetravel/presentation/provider/schedule_provider.dart';
import 'package:wetravel/presentation/widgets/package_item.dart';

class MainRecentlyPackages extends ConsumerWidget {
  const MainRecentlyPackages({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final state = ref.watch(mainPageViewModel);
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
            child: state.isLoading
                ? Center(
                    child:
                        CircularProgressIndicator(color: AppColors.primary_450))
                : state.recentPackages.isNotEmpty
                    ? ListView.builder(
                        clipBehavior: Clip.none,
                        scrollDirection: Axis.horizontal,
                        itemCount: state.recentPackages.length,
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
                                        packageId:
                                            state.recentPackages[index].id,
                                        getPackageUseCase: getPackageUseCase,
                                        getSchedulesUseCase:
                                            getSchedulesUseCase,
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: AppShadow.generalShadow,
                                  borderRadius: AppBorderRadius.small12,
                                  color: Colors.white,
                                ),
                                child: PackageItem(
                                  title: state.recentPackages[index].title,
                                  location:
                                      state.recentPackages[index].location,
                                  guideImageUrl:
                                      state.recentPackages[index].userImageUrl,
                                  packageImageUrl:
                                      state.recentPackages[index].imageUrl,
                                  name: state.recentPackages[index].userName,
                                  keywords: state
                                      .recentPackages[index].keywordList!
                                      .toList(),
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
