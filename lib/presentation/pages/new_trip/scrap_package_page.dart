import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wetravel/presentation/provider/package_provider.dart';
import 'package:wetravel/presentation/widgets/package_item.dart';
import 'package:wetravel/core/constants/app_spacing.dart';

class ScrapPackagesPage extends ConsumerWidget {
  const ScrapPackagesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrapPackagesAsync = ref.watch(scrapPackagesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('스크랩한 패키지')),
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

                return PackageItem(
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
                                      Navigator.of(context).pop(false), // No
                                  child: const Text("아니오"),
                                ),
                                CupertinoDialogAction(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true), // Yes
                                  isDestructiveAction: true, // Make "Yes" red
                                  child: const Text("네"),
                                ),
                              ],
                            );
                          },
                        ) ??
                        false; // Handle null case

                    if (confirmed) {
                      await _removeScrapPackage(ref, packageId);
                    }
                  },
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
      final auth = FirebaseAuth.instance; // Get FirebaseAuth instance

      final userId = auth.currentUser?.uid; // Get current user's UID
      if (userId == null) {
        // Handle the case where the user is not logged in.  Show a message or navigate to the login screen.
        print("User is not logged in!");
        return; // Important: Stop execution if no user
      }

      final userDocRef =
          firestore.collection('users').doc(userId); // Use userId here

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
      // Show error message to the user (SnackBar, dialog, etc.)
    }
  }
}
