import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_icons.dart';
import 'package:wetravel/core/constants/app_spacing.dart';
import 'package:wetravel/presentation/pages/guide/package_register_page/package_register_page.dart';
import 'package:wetravel/presentation/pages/guide/widgets/guide_info.dart';
import 'package:wetravel/presentation/widgets/package_item.dart';

class GuidePackageListPage extends StatelessWidget {
  const GuidePackageListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> guidePackages = [
      "파리 3박 4일 투어",
      "제주도 힐링 여행",
      "도쿄 먹방 여행",
      "파리 3박 4일 투어",
      "제주도 힐링 여행",
      "도쿄 먹방 여행",
      "파리 3박 4일 투어",
      "제주도 힐링 여행",
      "도쿄 먹방 여행",
    ];

    return Scaffold(
      body: SingleChildScrollView(
        padding: AppSpacing.large20,
        child: Column(
          spacing: 16,
          children: [
            SingleChildScrollView(
              child: GuideInfo(),
            ),
            ListView.separated(
              separatorBuilder: (context, index) {
                return SizedBox(height: 8);
              },
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: guidePackages.length,
              itemBuilder: (context, index) {
                return PackageItem(
                  title: guidePackages[index],
                  location: '도쿄',
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PackageRegisterPage(),
              ));
        },
        backgroundColor: AppColors.primary_450,
        elevation: 0,
        child: SvgPicture.asset(
          AppIcons.plus,
          width: 30,
          color: Colors.white,
        ),
      ),
    );
  }
}
