import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_shadow.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/core/constants/firestore_constants.dart';
import 'package:wetravel/presentation/pages/guide_package_detail_page/package_detail_page.dart';
import 'package:wetravel/presentation/provider/package_provider.dart';
import 'package:wetravel/presentation/widgets/package_item.dart';

class ScrapPackagesPage extends ConsumerStatefulWidget {
  const ScrapPackagesPage({super.key});

  @override
  _ScrapPackagesPageState createState() => _ScrapPackagesPageState();
}

class _ScrapPackagesPageState extends ConsumerState<ScrapPackagesPage> {
  late final Stream<User?> authStateStream;

  @override
  void initState() {
    super.initState();
    authStateStream = FirebaseAuth.instance.authStateChanges();
  }

  Future<void> _removeScrapPackage(String packageId) async {
    final firestoreConstants = FirestoreConstants();

    try {
      final firestore = FirebaseFirestore.instance;
      final auth = FirebaseAuth.instance;

      final userId = auth.currentUser?.uid;
      if (userId == null) {
        print("User is not logged in!");
        return;
      }

      final userDocRef =
          firestore.collection(firestoreConstants.usersCollection).doc(userId);

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

      ref.invalidate(scrapPackagesProvider); // 새로고침을 트리거합니다.
    } catch (e) {
      debugPrint('스크랩 해제 실패: $e');
    }
  }

  Future<Map<String, String>> fetchUserNameAndImageUrl(String userId) async {
    final firestore = FirebaseFirestore.instance;
    final firebaseConstants = FirestoreConstants();
    try {
      final userDoc = await firestore
          .collection(firebaseConstants.usersCollection)
          .doc(userId)
          .get();
      if (userDoc.exists) {
        final userData = userDoc.data()!;
        return {
          'name': userData['name'] ?? 'no name',
          'imageUrl': userData['imageUrl'] ?? '',
        };
      }
      return {'name': 'no name', 'imageUrl': ''};
    } catch (e) {
      print('Error fetching user data: $e');
      return {'name': 'no name', 'imageUrl': ''};
    }
  }

  @override
  Widget build(BuildContext context) {
    final scrapPackagesFuture =
        ref.watch(scrapPackagesProvider.future); // 자동 리빌드를 사용

    return StreamBuilder<User?>(
      stream: authStateStream,
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
            color: AppColors.primary_450,
          ));
        }

        if (authSnapshot.hasError) {
          return Center(child: Text('인증 오류 발생: ${authSnapshot.error}'));
        }

        final user = authSnapshot.data;
        if (user == null) {
          return const Center(child: Text('로그인 후 이용해 주세요.'));
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              '내가 담은 가이드 패키지',
              style: AppTypography.headline4.copyWith(
                color: AppColors.grayScale_950,
              ),
            ),
          ),
          body: FutureBuilder<List<dynamic>>(
            future: scrapPackagesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: AppColors.primary_450,
                ));
              }
              if (snapshot.hasError) {
                return Center(child: Text('오류 발생: ${snapshot.error}'));
              }
              final packages = snapshot.data ?? [];

              if (packages.isEmpty) {
                return const Center(child: Text('스크랩한 패키지가 없습니다.'));
              }

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: packages.length,
                      itemBuilder: (context, index) {
                        final package = packages[index];
                        final packageId = package['id'];
                        final userId = package['userId'];
                        return FutureBuilder<Map<String, String>>(
                          future: fetchUserNameAndImageUrl(userId),
                          builder: (context, userSnapshot) {
                            if (userSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator(
                                color: AppColors.primary_450,
                              ));
                            }
                            if (userSnapshot.hasError) {
                              return Center(
                                  child: Text(
                                      '사용자 정보 불러오기 실패: ${userSnapshot.error}'));
                            }

                            final userData = userSnapshot.data ??
                                {'name': 'no name', 'imageUrl': ''};

                            return Container(
                              margin: EdgeInsets.fromLTRB(16, 12, 16, 0),
                              decoration: BoxDecoration(
                                  boxShadow: AppShadow.generalShadow),
                              child: GestureDetector(
                                onTap: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return PackageDetailPage(
                                          packageId: packageId,
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: PackageItem(
                                  title: package['title'] ?? '제목 없음',
                                  location: package['location'] ?? '위치 정보 없음',
                                  packageImageUrl: package['imageUrl'] ?? '',
                                  guideImageUrl: userData['imageUrl'] ?? '',
                                  name: userData['name'] ?? '가이드 정보 없음',
                                  keywords: List<String>.from(
                                      package['keywordList'] ?? []),
                                  icon: const Icon(Icons.bookmark,
                                      color: AppColors.red),
                                  onIconTap: () async {
                                    final confirmed =
                                        await showCupertinoDialog<bool>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return CupertinoAlertDialog(
                                                  title: const Text("패키지 삭제"),
                                                  content: const Text(
                                                      "스크랩 목록에서 삭제하시겠습니까?"),
                                                  actions: [
                                                    CupertinoDialogAction(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(false),
                                                      child: const Text("아니오"),
                                                    ),
                                                    CupertinoDialogAction(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(true),
                                                      isDestructiveAction: true,
                                                      child: const Text("네"),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ) ??
                                            false;
                                    if (confirmed) {
                                      await _removeScrapPackage(packageId);
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
