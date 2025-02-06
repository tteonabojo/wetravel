import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/presentation/pages/main/main_page_view_model.dart';
import 'package:wetravel/presentation/pages/main/widgets/main_banner.dart';
import 'package:wetravel/presentation/pages/main/widgets/main_popular_packages.dart';
import 'package:wetravel/presentation/pages/main/widgets/main_recently_packages.dart';

class MainPage extends ConsumerStatefulWidget {
  /// 메인 페이지
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(mainPageViewModel);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              MainBanner(),
              SizedBox(height: 20),
              MainRecentlyPackages(recentPackages: vm.recentPackages),
              SizedBox(height: 20),
              MainPopularPackages(popularPackages: vm.popularPackages),
            ],
          ),
        ),
      ),
    );
  }
}
