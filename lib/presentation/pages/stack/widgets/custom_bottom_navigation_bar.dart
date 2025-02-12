import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final BuildContext context;
  final WidgetRef ref;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.context,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            AppIcons.home,
            color: AppColors.grayScale_550,
          ),
          activeIcon: SvgPicture.asset(
            AppIcons.home,
            color: AppColors.primary_450,
          ),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            AppIcons.squarePlus,
            color: AppColors.grayScale_550,
          ),
          activeIcon: SvgPicture.asset(
            AppIcons.squarePlus,
            color: AppColors.primary_450,
          ),
          label: '여행 시작',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            AppIcons.crown,
            color: AppColors.grayScale_550,
          ),
          activeIcon: SvgPicture.asset(
            AppIcons.crown,
            color: AppColors.primary_450,
          ),
          label: '가이드',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            AppIcons.userRound,
            color: AppColors.grayScale_550,
          ),
          activeIcon: SvgPicture.asset(
            AppIcons.userRound,
            color: AppColors.primary_450,
          ),
          label: '마이페이지',
        ),
      ],
      currentIndex: selectedIndex,
      onTap: (index) {
        onItemTapped(index);
      },
      selectedFontSize: 0,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
    );
  }
}
