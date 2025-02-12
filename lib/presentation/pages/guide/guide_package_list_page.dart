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
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/presentation/pages/guide/package_edit_page/package_edit_page.dart';
import 'package:wetravel/presentation/pages/guide/package_register_page/package_register_page.dart';
import 'package:wetravel/presentation/pages/guide_package_detail_page/package_detail_page.dart';
import 'package:wetravel/presentation/provider/schedule_provider.dart';
import 'package:wetravel/presentation/provider/user_provider.dart';
import 'package:wetravel/presentation/provider/package_provider.dart';
import 'package:wetravel/presentation/widgets/buttons/chip_button.dart';
import 'package:wetravel/presentation/widgets/package_item.dart';

class GuidePackageListPage extends ConsumerStatefulWidget {
  const GuidePackageListPage({super.key});

  @override
  _GuidePackageListPageState createState() => _GuidePackageListPageState();
}

class _GuidePackageListPageState extends ConsumerState<GuidePackageListPage> {
  bool showHiddenPackages = true;

  Future<Map<String, dynamic>> loadData(ref) async {
    try {
      final fetchUserUsecase = ref.read(fetchUserUsecaseProvider);
      final user = await fetchUserUsecase.execute();

      final fetchUserPackagesUsecase =
          ref.read(fetchUserPackagesUsecaseProvider);
      final packages = await fetchUserPackagesUsecase.execute(user.id);

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

  Future<void> _toggleIsHidden(String packageId, bool currentStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('packages')
          .doc(packageId)
          .update({'isHidden': !currentStatus});

      setState(() {
        showHiddenPackages = !showHiddenPackages;
      });
    } catch (e) {
      print('isHidden 변경 실패: $e');
    }
  }

  Future<void> _deletePackage(String packageId) async {
    try {
      final packageDoc = await FirebaseFirestore.instance
          .collection('packages')
          .doc(packageId)
          .get();

      if (packageDoc.exists) {
        final imageUrl = packageDoc.data()?['imageUrl'] as String?;

        if (imageUrl != null && imageUrl.isNotEmpty) {
          final storageRef = FirebaseStorage.instance.refFromURL(imageUrl);
          await storageRef.delete();
        }
      }

      final schedulesQuerySnapshot = await FirebaseFirestore.instance
          .collection('schedules')
          .where('packageId', isEqualTo: packageId)
          .get();

      await FirebaseFirestore.instance
          .collection('packages')
          .doc(packageId)
          .delete();

      for (var scheduleDoc in schedulesQuerySnapshot.docs) {
        await scheduleDoc.reference.delete();
      }

      setState(() {});
    } catch (e) {
      print('패키지 및 관련 스케줄 삭제 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final getPackageUseCase = ref.read(getPackageUseCaseProvider);
    final getSchedulesUseCase = ref.read(getSchedulesUseCaseProvider);
    return Scaffold(
      body: Padding(
        padding: AppSpacing.medium16,
        child: Column(
          children: [
            Row(
              children: [
                ChipButton(
                  disabledType: DisabledType.disabled150,
                  text: "비공개 리스트",
                  isSelected: showHiddenPackages,
                  onPressed: () {
                    setState(() {
                      showHiddenPackages = true;
                    });
                  },
                ),
                const SizedBox(width: 10),
                ChipButton(
                  disabledType: DisabledType.disabled150,
                  text: "공개 리스트",
                  isSelected: !showHiddenPackages,
                  onPressed: () {
                    setState(() {
                      showHiddenPackages = false;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<Map<String, dynamic>>(
                future: loadData(ref),
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
                  final packages = (snapshot.data!['packages'] as List)
                      .where(
                          (package) => package.isHidden == showHiddenPackages)
                      .toList();

                  if (packages.isEmpty) {
                    return Center(
                        child: Text(showHiddenPackages
                            ? '비공개 패키지가 없습니다.'
                            : '공개 패키지가 없습니다.'));
                  }

                  return ListView.separated(
                    itemCount: packages.length,
                    itemBuilder: (context, index) {
                      final package = packages[index];
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
                                title: Text(
                                  package.title,
                                  style: AppTypography.headline4
                                      .copyWith(color: AppColors.grayScale_950),
                                ),
                                actions: <CupertinoActionSheetAction>[
                                  CupertinoActionSheetAction(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      await _toggleIsHidden(
                                          package.id, package.isHidden);
                                    },
                                    child: Text(
                                      package.isHidden ? '공개 전환' : '비공개 전환',
                                      style: AppTypography.buttonLabelNormal
                                          .copyWith(
                                        color: AppColors.primary_550,
                                      ),
                                    ),
                                  ),
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
                                    child: Text(
                                      '수정',
                                      style: AppTypography.buttonLabelNormal
                                          .copyWith(
                                              color: AppColors.primary_550),
                                    ),
                                  ),
                                  CupertinoActionSheetAction(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      await _deletePackage(package.id);
                                      ref.invalidate(
                                          fetchUserPackagesUsecaseProvider);
                                      await loadData(ref);
                                      ref
                                          .read(
                                              fetchUserPackagesUsecaseProvider)
                                          .execute(user.id);
                                    },
                                    isDestructiveAction: true,
                                    child: Text(
                                      '삭제',
                                      style: AppTypography.buttonLabelNormal
                                          .copyWith(color: AppColors.red),
                                    ),
                                  ),
                                ],
                                cancelButton: CupertinoActionSheetAction(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    '취소',
                                    style: AppTypography.buttonLabelNormal
                                        .copyWith(
                                            color: AppColors.grayScale_550),
                                  ),
                                ),
                              ),
                            );
                          },
                          title: package.title,
                          location: package.location,
                          guideImageUrl: user.imageUrl ?? '',
                          name: user.name ?? '이름 없음',
                          keywords: package.keywordList ?? ['키워드 없음'],
                          packageImageUrl: package.imageUrl ?? '',
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: 8);
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
