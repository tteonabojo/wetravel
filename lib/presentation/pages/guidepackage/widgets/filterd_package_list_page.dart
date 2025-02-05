import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/presentation/provider/recommendation_provider.dart';
import 'package:wetravel/presentation/widgets/package_item.dart';

class FilteredPackageListWidget extends ConsumerWidget {
  final double? height;
  final double? width;

  const FilteredPackageListWidget({
    super.key,
    this.height,
    this.width,
  });

  Future<List<Map<String, dynamic>>> fetchFilteredPackages(
      List<String> selectedKeywords) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('packages')
          .where('keywordList', arrayContainsAny: selectedKeywords)
          .get();

      print('Packages: ${querySnapshot.docs.length}');
      querySnapshot.docs.forEach((doc) {
        print(doc.data());
      });

      final filteredPackages = querySnapshot.docs
          .where((doc) {
            final packageKeywords = List<String>.from(doc['keywordList'] ?? []);
            return selectedKeywords
                .any((keyword) => packageKeywords.contains(keyword));
          })
          .map((doc) => doc.data())
          .toList();

      return filteredPackages;
    } catch (e) {
      print('Error fetching filtered packages: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedKeywords =
        ref.watch(recommendationStateProvider).selectedKeywords;

    return SizedBox(
      height: height ?? double.infinity,
      width: width ?? double.infinity,
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchFilteredPackages(selectedKeywords),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('에러 발생: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('추천 패키지가 없습니다.'));
          }

          final packages = snapshot.data ?? [];

          print('Fetched packages: $packages'); // 디버그용

          return ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(8.0),
            itemCount: packages.length,
            itemBuilder: (context, index) {
              final package = packages[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: PackageItem(
                  title: package['title'],
                  location: package['location'],
                  guideImageUrl: package['guideImageUrl'] ?? '',
                  name: package['name'] ?? '이름 없음',
                  keywords: List<String>.from(package['keywordList'] ?? []),
                  packageImageUrl: package['imageUrl'] ?? '',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
