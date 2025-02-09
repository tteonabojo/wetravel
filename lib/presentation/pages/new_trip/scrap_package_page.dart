import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/presentation/pages/guidepackagedetailpage/package_detail_page.dart';
import 'package:wetravel/presentation/provider/package_provider.dart';
import 'package:wetravel/presentation/provider/schedule_provider.dart';
import 'package:wetravel/presentation/widgets/package_item.dart';
import 'package:wetravel/core/constants/app_spacing.dart';

class ScrapPackagesPage extends ConsumerWidget {
  const ScrapPackagesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final getPackageUseCase = ref.read(getPackageUseCaseProvider);
    final getSchedulesUseCase = ref.read(getSchedulesUseCaseProvider);
    final scrapPackagesAsync = ref.watch(scrapPackagesProvider);
    return Scaffold(
      appBar: AppBar(
          title: Text(
        '내가 담은 가이드 패키지',
        style: AppTypography.headline4.copyWith(
          color: AppColors.grayScale_950,
        ),
      )),
      body: Padding(
        padding: AppSpacing.medium16,
        child: scrapPackagesAsync.when(
          data: (packages) {
            if (packages.isEmpty) {
              return const Center(child: Text('스크랩한 패키지가 없습니다.'));
            }
            return ListView.separated(
              itemCount: packages.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final package = packages[index];
                final packageId = package['id'];

                return GestureDetector(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return PackageDetailPage(
                            packageId: packageId,
                            getPackageUseCase: getPackageUseCase,
                            getSchedulesUseCase: getSchedulesUseCase,
                          );
                        },
                      ),
                    );
                  },
                  child: PackageItem(
                    title: package['title'] ?? '제목 없음',
                    location: package['location'] ?? '위치 정보 없음',
                    packageImageUrl: package['imageUrl'] ?? '',
                    guideImageUrl: package['userImageUrl'] ?? '',
                    name: package['userName'] ?? '가이드 정보 없음',
                    keywords: List<String>.from(package['keywordList'] ?? []),
                    icon: const Icon(Icons.bookmark, color: Colors.red),
                    onIconTap: () async {
                      final confirmed = await showCupertinoDialog<bool>(
                            context: context,
                            builder: (BuildContext context) {
                              return CupertinoAlertDialog(
                                title: const Text("패키지 삭제"),
                                content: const Text("스크랩 목록에서 삭제하시겠습니까?"),
                                actions: [
                                  CupertinoDialogAction(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text("아니오"),
                                  ),
                                  CupertinoDialogAction(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    isDestructiveAction: true,
                                    child: const Text("네"),
                                  ),
                                ],
                              );
                            },
                          ) ??
                          false;

                      if (confirmed) {
                        await _removeScrapPackage(ref, packageId);
                      }
                    },
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('오류 발생: $err')),
        ),
      ),
    );
  }

  Future<void> _removeScrapPackage(WidgetRef ref, String packageId) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final auth = FirebaseAuth.instance;

      final userId = auth.currentUser?.uid;
      if (userId == null) {
        print("User is not logged in!");
        return;
      }

      final userDocRef = firestore.collection('users').doc(userId);

      await firestore.runTransaction((transaction) async {
        final userDoc = await transaction.get(userDocRef);
        if (!userDoc.exists) return;

        final List<String> scrapIdList =
            List<String>.from(userDoc.data()?['scrapIdList'] ?? []);

        if (scrapIdList.contains(packageId)) {
          scrapIdList.remove(packageId);
          transaction.update(userDocRef, {'scrapIdList': scrapIdList});
        }
      });

      ref.invalidate(scrapPackagesProvider);
    } catch (e) {
      debugPrint('스크랩 해제 실패: $e');
    }
  }
}
