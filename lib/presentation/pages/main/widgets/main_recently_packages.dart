import 'package:flutter/material.dart';
import 'package:wetravel/presentation/pages/main/widgets/main_label.dart';
import 'package:wetravel/presentation/widgets/package_item.dart';

class MainRecentlyPackages extends StatelessWidget {
  const MainRecentlyPackages({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 168,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          MainLabel(label: '최근에 본 일정 패키지'),
          SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                PackageItem(),
                SizedBox(width: 20),
                PackageItem(),
                SizedBox(width: 20),
                PackageItem(),
                SizedBox(width: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
