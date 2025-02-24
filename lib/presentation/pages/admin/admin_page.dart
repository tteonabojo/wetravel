import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_icons.dart';
import 'package:wetravel/core/constants/app_shadow.dart';
import 'package:wetravel/core/constants/app_spacing.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/core/constants/firestore_constants.dart';
import 'package:wetravel/presentation/pages/guide/package_edit_page/package_edit_page.dart';
import 'package:wetravel/presentation/pages/guide_package_detail_page/package_detail_page.dart';
import 'package:wetravel/presentation/provider/package_provider.dart';
import 'package:wetravel/presentation/provider/user_provider.dart';
import 'package:wetravel/presentation/widgets/buttons/chip_button.dart';
import 'package:wetravel/presentation/widgets/package_item.dart';

class AdminPage extends ConsumerStatefulWidget {
  const AdminPage({super.key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends ConsumerState<AdminPage> {
  bool showHiddenPackages = false;
  String selectedFilter = '전체 패키지';
  final FirestoreConstants firestoreConstants = FirestoreConstants();

  @override
  Widget build(BuildContext context) {
    final packagesAsync = ref.watch(packagesProvider);

    return Scaffold(
      appBar: AppBar(
          title: Text(
        '패키지 관리',
        style: AppTypography.headline4.copyWith(color: AppColors.grayScale_950),
      )),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: ['전체 패키지', '공개 패키지', '비공개 패키지'].map((filter) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChipButton(
                  disabledType: DisabledType.disabled150,
                  text: filter,
                  isSelected: selectedFilter == filter,
                  onPressed: () {
                    setState(() {
                      selectedFilter = filter;
                    });
                  },
                ),
              );
            }).toList(),
          ),
          Expanded(
            child: packagesAsync.when(
              data: (packages) {
                final filteredPackages = packages.where((package) {
                  if (selectedFilter == '공개 패키지') {
                    return !package.isHidden;
                  } else if (selectedFilter == '비공개 패키지') {
                    return package.isHidden;
                  }
                  return true;
                }).toList();

                if (filteredPackages.isEmpty) {
                  return Center(child: Text('등록된 패키지가 없습니다.'));
                }
                return ListView.builder(
                  padding: AppSpacing.medium16,
                  itemCount: filteredPackages.length,
                  itemBuilder: (context, index) {
                    final package = filteredPackages[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: AppShadow.generalShadow,
                          borderRadius: AppBorderRadius.small12,
                          color: Colors.white,
                        ),
                        child: GestureDetector(
                          onTap: () async {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return PackageDetailPage(
                                  packageId: package.id,
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
                                    style: AppTypography.headline4.copyWith(
                                        color: AppColors.grayScale_950),
                                  ),
                                  actions: <CupertinoActionSheetAction>[
                                    CupertinoActionSheetAction(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PackageEditPage(
                                                      packageId: package.id)),
                                        );
                                      },
                                      child: Text('수정',
                                          style: AppTypography.buttonLabelNormal
                                              .copyWith(
                                                  color:
                                                      AppColors.primary_550)),
                                    ),
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
                                          color: package.isHidden
                                              ? AppColors.primary_550
                                              : AppColors.red,
                                        ),
                                      ),
                                    ),
                                    CupertinoActionSheetAction(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        await _deletePackage(package.id);
                                        ref.invalidate(
                                            fetchUserPackagesUsecaseProvider);
                                      },
                                      isDestructiveAction: true,
                                      child: Text('삭제',
                                          style: AppTypography.buttonLabelNormal
                                              .copyWith(color: AppColors.red)),
                                    ),
                                  ],
                                  cancelButton: CupertinoActionSheetAction(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('취소',
                                        style: AppTypography.buttonLabelNormal
                                            .copyWith(
                                                color:
                                                    AppColors.grayScale_550)),
                                  ),
                                ),
                              );
                            },
                            packageImageUrl: package.imageUrl,
                            title: package.title,
                            keywords: package.keywordList!,
                            location: package.location,
                            guideImageUrl: package.userImageUrl,
                            name: package.userName,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => Center(
                  child: CircularProgressIndicator(
                color: AppColors.primary_450,
              )),
              error: (error, stack) => Center(child: Text('오류 발생: $error')),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleIsHidden(String packageId, bool currentStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection(firestoreConstants.packagesCollection)
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
          .collection(firestoreConstants.packagesCollection)
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
          .collection(firestoreConstants.schedulesCollection)
          .where('packageId', isEqualTo: packageId)
          .get();

      await FirebaseFirestore.instance
          .collection(firestoreConstants.packagesCollection)
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

  Future<Map<String, dynamic>> loadData(ref) async {
    try {
      final fetchUserUsecase = ref.read(fetchUserUsecaseProvider);
      final user = await fetchUserUsecase.execute();

      final fetchUserPackagesUsecase =
          ref.read(fetchUserPackagesUsecaseProvider);
      final packages = await fetchUserPackagesUsecase.execute(user.id);

      return {
        firestoreConstants.usersCollection: user,
        firestoreConstants.packagesCollection: packages,
      };
    } catch (e, stackTrace) {
      print('Admin loadData 에러: $e');
      print('에러 위치: $stackTrace');
      rethrow;
    }
  }
}
