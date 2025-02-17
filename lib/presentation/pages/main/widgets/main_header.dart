import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_icons.dart';
import 'package:wetravel/core/constants/app_typography.dart';

class MainHeader extends StatelessWidget {
  final int selectedIndex;

  const MainHeader({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: double.infinity,
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: selectedIndex == 0
            ? Row(
                children: [
                  SvgPicture.asset(AppIcons.logoBgNone40),
                  SvgPicture.asset(AppIcons.logoLetter, height: 18),
                ],
              )
            : Text(
                _getPageTitle(selectedIndex),
                style: AppTypography.headline3.copyWith(
                  color: AppColors.grayScale_950,
                ),
              ),
      ),
    );
  }

  String _getPageTitle(int index) {
    switch (index) {
      case 1:
        return "패키지 생성";
      case 2:
        return "내가 작성한 패키지";
      case 3:
        return "마이페이지";
      default:
        return "";
    }
  }
}
