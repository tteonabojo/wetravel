import 'package:flutter/material.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_shadow.dart';
import 'package:wetravel/domain/entity/package.dart';
import 'package:wetravel/presentation/pages/guide_package_detail_page/package_detail_page.dart';
import 'package:wetravel/presentation/widgets/package_item.dart';

class PopularPackageListItem extends StatelessWidget {
  const PopularPackageListItem({
    super.key,
    required this.index,
    required this.guideName,
    required this.guideProfileUrl,
    required this.package,
  });

  final int index;
  final Package package;
  final String? guideName;
  final String? guideProfileUrl;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return PackageDetailPage(
                packageId: package.id,
              );
            },
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8.0),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: AppShadow.generalShadow,
            borderRadius: AppBorderRadius.small12,
          ),
          child: SizedBox(
            width: double.infinity,
            child: PackageItem(
              rate: index < 3 ? index + 1 : null,
              title: package.title,
              location: package.location,
              guideImageUrl: guideProfileUrl,
              packageImageUrl: package.imageUrl,
              name: guideName,
              keywords: package.keywordList!.toList(),
            ),
          ),
        ),
      ),
    );
  }
}
