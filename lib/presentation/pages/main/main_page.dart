import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/presentation/pages/main/main_page_view_model.dart';
import 'package:wetravel/presentation/pages/main/widgets/main_banner.dart';
import 'package:wetravel/presentation/pages/main/widgets/main_label.dart';
import 'package:wetravel/presentation/pages/main/widgets/main_recently_packages.dart';
import 'package:wetravel/presentation/pages/main/widgets/popular_package_list_item.dart';

class MainPage extends ConsumerStatefulWidget {
  /// 메인 페이지
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    ref.read(mainPageViewModel.notifier).watchRecentPackages();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    final vm = ref.read(mainPageViewModel.notifier);
    await vm.refreshData();
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(mainPageViewModel);

    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: ListView(
            controller: _scrollController,
            children: [
              MainBanner(banners: vm.banners),
              MainRecentlyPackages(recentPackages: vm.recentPackages),
              SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: MainLabel(label: '인기 있는 패키지'),
              ),
              ...popularPackages(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> popularPackages() {
    final mainPageState = ref.watch(mainPageViewModel);
    final packages = mainPageState.popularPackages;
    final users = mainPageState.userMap;
    return packages.map((e) {
      final user = users[e.userId];
      return PopularPackageListItem(
        index: packages.indexOf(e),
        guideName: user?.name ?? e.userName,
        guideProfileUrl: user?.imageUrl ?? e.userImageUrl,
        package: e,
      );
    }).toList();
  }
}
