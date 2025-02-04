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

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // NewTripPage의 내용을 여기로 이동
              Row(
                children: const [
                  Text(
                    '위트',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    MainBanner(),
                    SizedBox(height: 20),
                    MainRecentlyPackages(recentPackages: vm.recentPackages),
                    SizedBox(height: 20),
                    MainPopularPackages(popularPackages: vm.popularPackages),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
