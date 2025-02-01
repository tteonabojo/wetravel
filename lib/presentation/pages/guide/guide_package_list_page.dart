import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_icons.dart';
import 'package:wetravel/core/constants/app_shadow.dart';
import 'package:wetravel/core/constants/app_spacing.dart';
import 'package:wetravel/presentation/pages/guide/package_register_page.dart';
import 'package:wetravel/presentation/widgets/package_item.dart';

class GuidePackageListPage extends StatelessWidget {
  const GuidePackageListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> guidePackages = ["파리 3박 4일 투어", "제주도 힐링 여행", "도쿄 먹방 여행"];

    return Scaffold(
      body: SingleChildScrollView(
        padding: AppSpacing.large20,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 100,
              padding: AppSpacing.medium16,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: AppBorderRadius.small12,
                ),
                shadows: AppShadow.generalShadow,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/sample_profile.jpg'),
                        fit: BoxFit.cover,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '나는 이구역짱',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                            height: 1.43,
                            letterSpacing: -0.28,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '가이드님 환영합니다',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                            height: 1.71,
                            letterSpacing: -0.28,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              separatorBuilder: (context, index) {
                return SizedBox(height: 8);
              },
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), // 내부 스크롤 막음
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
