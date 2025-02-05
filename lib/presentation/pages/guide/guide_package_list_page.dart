import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_icons.dart';
import 'package:wetravel/core/constants/app_spacing.dart';
import 'package:wetravel/presentation/pages/guide/package_edit_page/package_edit_page.dart';
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
    try {
      final fetchUserUsecase = ref.read(fetchUserUsecaseProvider);
      final user = await fetchUserUsecase.execute();
      print('유저 데이터: ${user.toString()}');

      final fetchUserPackagesUsecase =
          ref.read(fetchUserPackagesUsecaseProvider);
      final packages = await fetchUserPackagesUsecase.execute(user.id);
      print('패키지 데이터: ${packages.toString()}');

      return {
        'user': user,
        'packages': packages,
      };
    } catch (e, stackTrace) {
      print('loadData 에러: $e');
      print('에러 위치: $stackTrace');
      rethrow;
    }
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
      print('패키지 문서 데이터: ${packageDoc.data()}');

      if (packageDoc.exists) {
        return packageDoc.data()?['imageUrl'] as String?;
      }
    } catch (e) {
      print('Error fetching package image URL: $e');
    }
    return null;
  }

  Future<void> _deletePackage(String packageId) async {
    try {
      // 1. Firestore에서 패키지 정보 삭제
      final packageDoc = await FirebaseFirestore.instance
          .collection('packages')
          .doc(packageId)
          .get();

      if (packageDoc.exists) {
        final imageUrl = packageDoc.data()?['imageUrl'] as String?;

        // 2. Firebase Storage에서 이미지 삭제 (이미지가 존재하는 경우)
        if (imageUrl != null && imageUrl.isNotEmpty) {
          final storageRef = FirebaseStorage.instance.refFromURL(imageUrl);
          await storageRef.delete();
          print('스토리지에서 이미지 삭제 성공');
        }
      }

      // 3. Firestore에서 패키지 삭제
      await FirebaseFirestore.instance
          .collection('packages')
          .doc(packageId)
          .delete();
      print('패키지 삭제 성공');

      // 4. 해당 패키지와 관련된 모든 스케줄 삭제
      final schedulesQuerySnapshot = await FirebaseFirestore.instance
          .collection('schedules')
          .where('packageId', isEqualTo: packageId)
          .get();

      for (var scheduleDoc in schedulesQuerySnapshot.docs) {
        await scheduleDoc.reference.delete();
        print('스케줄 삭제 성공: ${scheduleDoc.id}');
      }
    } catch (e) {
      print('패키지 및 관련 스케줄 삭제 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context, ref) {
    final getPackageUseCase = ref.read(getPackageUseCaseProvider);
    final getSchedulesUseCase = ref.read(getSchedulesUseCaseProvider);

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
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child:
                          Text('내가 등록한 패키지 리스트 가져오기 Error: ${snapshot.error}'),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data == null) {
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
                              icon: SvgPicture.asset(AppIcons.ellipsisVertical),
                              onIconTap: () async {
                                showCupertinoModalPopup(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      CupertinoActionSheet(
                                    title: Text(package.title),
                                    actions: <CupertinoActionSheetAction>[
                                      CupertinoActionSheetAction(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PackageEditPage(
                                                      packageId: package.id,
                                                    )),
                                          );
                                        },
                                        child: const Text('수정'),
                                      ),
                                      CupertinoActionSheetAction(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          await _deletePackage(package.id);
                                          ref
                                              .read(
                                                  fetchUserPackagesUsecaseProvider)
                                              .execute(user.id);
                                        },
                                        isDestructiveAction: true,
                                        child: const Text('삭제'),
                                      ),
                                    ],
                                    cancelButton: CupertinoActionSheetAction(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('취소'),
                                    ),
                                  ),
                                );
                              },
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
