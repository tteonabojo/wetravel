import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_icons.dart';

class MainHeader extends StatelessWidget {
  /// 메인 페이지 로고 영역
  const MainHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: double.infinity,
      color: AppColors.grayScale_050,
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: SvgPicture.asset(AppIcons.logoBgNone40),
          ),
          SvgPicture.asset(AppIcons.logoLetter, height: 18),
        ],
      ),
    );
  }
}
