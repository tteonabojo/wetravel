import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_icons.dart';
import 'package:wetravel/core/constants/app_spacing.dart';
import 'package:wetravel/presentation/pages/guide/package_register_page/package_register_page.dart';
import 'package:wetravel/presentation/pages/guide/widgets/guide_info.dart';
import 'package:wetravel/presentation/pages/guidepackagedetailpage/package_detail_page.dart';
import 'package:wetravel/presentation/provider/schedule_provider.dart';
import 'package:wetravel/presentation/provider/user_provider.dart';
import 'package:wetravel/presentation/provider/package_provider.dart';
import 'package:wetravel/presentation/widgets/package_item.dart';

class GuidePackageListPage extends ConsumerWidget {
  const GuidePackageListPage({super.key});

  Future<Map<String, dynamic>> loadData(ref) async {
    final fetchUserUsecase = ref.read(fetchUserUsecaseProvider);
    final user = await fetchUserUsecase.execute();
    final fetchUserPackagesUsecase = ref.read(fetchUserPackagesUsecaseProvider);
    final packages = await fetchUserPackagesUsecase.execute(user.id);

    return {
      'user': user,
      'packages': packages,
    };
  }

  Future<T> withMinimumDelay<T>(Future<T> future, Duration minDuration) async {
    final results = await Future.wait([
      future,
      Future.delayed(minDuration),
    ]);
    return results.first as T;
  }

  Future<String?> _getPackageImageUrl(String packageId) async {
    try {
      final packageDoc = await FirebaseFirestore.instance
          .collection('packages')
          .doc(packageId)
          .get();
      if (packageDoc.exists) {
        return packageDoc.data()?['imageUrl'] as String?;
      }
    } catch (e) {
      print('Error fetching package image URL: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context, ref) {
    final getPackageUseCase =
        ref.read(getPackageUseCaseProvider); // use case 가져오기
    final getSchedulesUseCase =
        ref.read(getSchedulesUseCaseProvider); // use case 가져오기

    return Scaffold(
      body: Padding(
        padding: AppSpacing.large20,
        child: Column(
          spacing: 16,
          children: [
            const GuideInfo(),
            Expanded(
              child: FutureBuilder<Map<String, dynamic>>(
                future: withMinimumDelay(
                    loadData(ref), const Duration(milliseconds: 500)),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(
                            '내가 등록한 패키지 리스트 가져오기 Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData) {
                    return const Center(child: Text('데이터가 없습니다.'));
                  }

                  final user = snapshot.data!['user'];
                  final packages = snapshot.data!['packages'];

                  if (packages.isEmpty) {
                    return const Center(child: Text('등록된 패키지가 없습니다.'));
                  }

                  return ListView.separated(
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemCount: packages.length,
                    itemBuilder: (context, index) {
                      final package = packages[index];

                      // Firebase에서 패키지 이미지 URL 가져오기
                      return FutureBuilder<String?>(
                        future: _getPackageImageUrl(package.id),
                        builder: (context, imageSnapshot) {
                          String packageImageUrl = '';
                          if (imageSnapshot.connectionState ==
                              ConnectionState.done) {
                            if (imageSnapshot.hasData &&
                                imageSnapshot.data != null) {
                              packageImageUrl = imageSnapshot.data!;
                            }
                          }

                          return GestureDetector(
                            onTap: () async {
                              final fetchPackageSchedulesUsecase = ref
                                  .read(fetchPackageSchedulesUsecaseProvider);
                              final scheduleData =
                                  await fetchPackageSchedulesUsecase
                                      .execute(package.scheduleIdList);

                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return PackageDetailPage(
                                    packageId: package.id,
                                    getPackageUseCase: getPackageUseCase,
                                    getSchedulesUseCase: getSchedulesUseCase,
                                  );
                                },
                              ));
                            },
                            child: PackageItem(
                              title: package.title,
                              location: package.location,
                              guideImageUrl: user.imageUrl ?? '',
                              name: user.name ?? '이름 없음',
                              keywords: package.keywordList ??
                                  ['키워드 없음', '키워드 없음', '키워드 없음'],
                              packageImageUrl: packageImageUrl,
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const PackageRegisterPage()),
          );
        },
        backgroundColor: AppColors.primary_450,
        elevation: 0,
        child: SvgPicture.asset(
          AppIcons.plus,
          width: 30,
          color: Colors.white,
        ),
      ),
    );
  }
}
