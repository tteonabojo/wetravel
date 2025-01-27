import 'package:flutter/material.dart';
import 'package:wetravel/presentation/pages/main/widgets/main_banner.dart';
import 'package:wetravel/presentation/pages/main/widgets/main_header.dart';
import 'package:wetravel/presentation/pages/main/widgets/main_popular_packages.dart';
import 'package:wetravel/presentation/pages/main/widgets/main_recently_packages.dart';

class MainPage extends StatefulWidget {
  /// 메인 페이지
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            MainHeader(),
            MainBanner(),
            SizedBox(height: 20),
            MainRecentlyPackages(),
            MainPopularPackages(),
          ],
        ),
      ),
    );
  }
}
