import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_icons.dart';
import 'package:wetravel/presentation/pages/new_trip/new_trip_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final BuildContext context;
  final WidgetRef ref;
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({
    required this.context,
    required this.ref,
    required this.selectedIndex,
    required this.onItemTapped,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_box_outlined),
          label: '새 여행',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark_outline),
          label: '내가 담은 패키지',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: '프로필',
        ),
      ],
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
    );
  }
}
