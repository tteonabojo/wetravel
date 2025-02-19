import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_shadow.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/core/constants/firestore_constants.dart';
import 'package:wetravel/domain/entity/package.dart';
import 'package:wetravel/presentation/pages/guide_package_detail_page/package_detail_page.dart';
import 'package:wetravel/presentation/pages/main/widgets/main_label.dart';
import 'package:wetravel/presentation/provider/package_provider.dart';
import 'package:wetravel/presentation/provider/schedule_provider.dart';
import 'package:wetravel/presentation/widgets/package_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainPopularPackages extends ConsumerWidget {
  /// 메인 페이지 인기 패키지 영역
  final List<Package> popularPackages;

  const MainPopularPackages({super.key, required this.popularPackages});

  // Firestore에서 사용자 정보를 가져오는 함수
  Future<Map<String, String>> getUserInfo(String userId) async {
    final FirestoreConstants firestoreConstants = FirestoreConstants();
    try {
      var userDoc = await FirebaseFirestore.instance
          .collection(firestoreConstants.usersCollection)
          .doc(userId)
          .get();

      if (userDoc.exists) {
        return {
          'name': userDoc['name'] ?? 'no name',
          'imageUrl': userDoc['imageUrl'] ?? '',
        };
      }
    } catch (e) {
      print('Error fetching user info: $e');
    }
    return {'name': 'no name', 'imageUrl': ''};
  }

  @override
  Widget build(BuildContext context, ref) {
    final getPackageUseCase = ref.read(getPackageUseCaseProvider);
    final getSchedulesUseCase = ref.read(getSchedulesUseCaseProvider);

    // isHidden이 false인 패키지만 필터링
    final visiblePackages =
        popularPackages.where((package) => package.isHidden == false).toList();

    // 10개까지만 리스트를 자름
    final displayedPackages = visiblePackages.length > 10
        ? visiblePackages.sublist(0, 10)
        : visiblePackages;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: MainLabel(label: '인기 있는 패키지'),
        ),
        visiblePackages.isNotEmpty
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: List.generate(
                    displayedPackages.length,
                    (index) {
                      int? rate = index <= 2 ? index + 1 : null; // 3등 까지 순위 표시
                      return FutureBuilder<Map<String, String>>(
                        future: getUserInfo(displayedPackages[index].userId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error loading guide info.'));
                          }

                          var userInfo = snapshot.data;
                          return GestureDetector(
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return PackageDetailPage(
                                      packageId: displayedPackages[index].id,
                                      getPackageUseCase: getPackageUseCase,
                                      getSchedulesUseCase: getSchedulesUseCase,
                                    );
                                  },
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: AppShadow.generalShadow,
                                  borderRadius: AppBorderRadius.small12,
                                ),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: PackageItem(
                                    rate: rate,
                                    title: displayedPackages[index].title,
                                    location: displayedPackages[index].location,
                                    guideImageUrl: userInfo!['imageUrl']!,
                                    packageImageUrl:
                                        displayedPackages[index].imageUrl,
                                    name: userInfo['name']!,
                                    keywords: displayedPackages[index]
                                        .keywordList!
                                        .toList(),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              )
            : Container(
                constraints: BoxConstraints(minHeight: 120),
                child: Center(
                  child: Text(
                    '인기있는 패키지가 없어요',
                    style: AppTypography.body3,
                  ),
                ),
              ),
        SizedBox(height: 16)
      ],
    );
  }
}
