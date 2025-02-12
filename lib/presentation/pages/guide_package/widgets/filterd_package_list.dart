import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/presentation/pages/guide_package_detail_page/package_detail_page.dart';
import 'package:wetravel/presentation/provider/package_provider.dart';
import 'package:wetravel/presentation/provider/schedule_provider.dart';
import 'package:wetravel/presentation/widgets/package_item.dart';

class FilteredPackageList extends ConsumerWidget {
  final List<String> allKeywords;

  const FilteredPackageList({super.key, required this.allKeywords});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final getPackageUseCase = ref.read(getPackageUseCaseProvider);
    final getSchedulesUseCase = ref.read(getSchedulesUseCaseProvider);

    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('packages')
          .where('keywordList', arrayContainsAny: allKeywords)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error loading data'));
        }

        final packages = snapshot.data?.docs ?? [];

        if (packages.isEmpty) {
          return const Center(child: Text('No packages found'));
        }

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              itemCount: packages.length,
              itemBuilder: (context, index) {
                final packageData =
                    packages[index].data() as Map<String, dynamic>;
                final packageTitle = packageData['title'] ?? 'Untitled';
                final packageLocation = packageData['location'] ?? 'Unknown';
                final packageImageUrl = packageData['imageUrl'] ?? '';
                final packageKeywords =
                    List<String>.from(packageData['keywordList'] ?? []);
                final guideImageUrl = packageData['userImageUrl'] ?? '';
                final guideName = packageData['userName'] ?? 'Unknown Guide';
                final packageId = packages[index].id; // 패키지 id 추출

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: GestureDetector(
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
                      title: packageTitle,
                      location: packageLocation,
                      packageImageUrl: packageImageUrl,
                      keywords: packageKeywords,
                      guideImageUrl: guideImageUrl,
                      name: guideName,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
