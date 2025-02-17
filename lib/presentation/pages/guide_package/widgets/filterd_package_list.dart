import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: packages.length,
            itemBuilder: (context, index) {
              final packageData =
                  packages[index].data() as Map<String, dynamic>;
              final packageTitle = packageData['title'] ?? 'Untitled';
              final packageLocation = packageData['location'] ?? 'Unknown';
              final packageImageUrl = packageData['imageUrl'] ?? '';
              final packageKeywords =
                  List<String>.from(packageData['keywordList'] ?? []);
              final userId = packageData['userId'] ?? '';
              final userImageUrl = packageData['userImageUrl'] ?? '';
              final userName = packageData['userName'] ?? 'no name';

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection(firestoreConstants.usersCollection)
                    .doc(userId)
                    .get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: AppColors.primary_450,
                    ));
                  }

                  if (userSnapshot.hasError || !userSnapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        decoration:
                            BoxDecoration(boxShadow: AppShadow.generalShadow),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PackageDetailPage(
                                  packageId: packages[index].id,
                                  getPackageUseCase: getPackageUseCase,
                                  getSchedulesUseCase: getSchedulesUseCase,
                                ),
                              ),
                            );
                          },
                          child: PackageItem(
                            name: userName,
                            guideImageUrl: userImageUrl,
                            title: packageTitle,
                            location: packageLocation,
                            packageImageUrl: packageImageUrl,
                            keywords: packageKeywords,
                          ),
                        ),
                      ),
                    );
                  }

                  final userData =
                      userSnapshot.data?.data() as Map<String, dynamic>?;
                  final guideName = userData?['name'] ?? 'no name';
                  final guideImageUrl = userData?['imageUrl'] ?? '';

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      decoration:
                          BoxDecoration(boxShadow: AppShadow.generalShadow),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PackageDetailPage(
                                packageId: packages[index].id,
                                getPackageUseCase: getPackageUseCase,
                                getSchedulesUseCase: getSchedulesUseCase,
                              ),
                            ),
                          );
                        },
                        child: PackageItem(
                          name: guideName,
                          guideImageUrl: guideImageUrl,
                          title: packageTitle,
                          location: packageLocation,
                          packageImageUrl: packageImageUrl,
                          keywords: packageKeywords,
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
