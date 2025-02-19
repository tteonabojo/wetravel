import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_shadow.dart';
import 'package:wetravel/core/constants/firestore_constants.dart';
import 'package:wetravel/presentation/pages/guide_package_detail_page/package_detail_page.dart';
import 'package:wetravel/presentation/provider/package_provider.dart';
import 'package:wetravel/presentation/provider/schedule_provider.dart';
import 'package:wetravel/presentation/widgets/package_item.dart';

class FilteredPackageList extends ConsumerWidget {
  final List<String> selectedKeywords;
  final String? selectedCity;
  final FirestoreConstants firestoreConstants = FirestoreConstants();

  FilteredPackageList(
      {super.key, required this.selectedKeywords, this.selectedCity});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final getPackageUseCase = ref.read(getPackageUseCaseProvider);
    final getSchedulesUseCase = ref.read(getSchedulesUseCaseProvider);

    final query = FirebaseFirestore.instance
        .collection(firestoreConstants.packagesCollection)
        .where('keywordList', arrayContainsAny: selectedKeywords);

    if (selectedCity != null && selectedCity!.isNotEmpty) {
      query.where('location', isEqualTo: selectedCity);
    }

    return FutureBuilder<QuerySnapshot>(
      future: query.get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
            color: AppColors.primary_450,
          ));
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error loading data'));
        }

        final packages = snapshot.data?.docs ?? [];

        if (packages.isEmpty) {
          return const Center(child: Text('조건에 맞는 패키지가 없습니다.'));
        }

        return Expanded(
          // Column 내부에서 사용하려면 Expanded로 감싸기
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: packages.length,
            itemBuilder: (context, index) {
              final package = packages[index];
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(package['userId'])
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  final userData =
                      snapshot.data?.data() as Map<String, dynamic>? ?? {};
                  final userName = userData['name'] ?? 'no name';
                  final userImageUrl = userData['imageUrl'] ?? '';

                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == packages.length - 1 ? 40 : 8,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PackageDetailPage(
                              packageId: package.id,
                              getPackageUseCase: getPackageUseCase,
                              getSchedulesUseCase: getSchedulesUseCase,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: AppShadow.generalShadow,
                          borderRadius: AppBorderRadius.small12,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: PackageItem(
                            name: userName,
                            guideImageUrl: userImageUrl,
                            title: package['title'] ?? 'Untitled',
                            location: package['location'] ?? 'Unknown',
                            packageImageUrl: package['imageUrl'] ?? '',
                            keywords:
                                List<String>.from(package['keywordList'] ?? []),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
