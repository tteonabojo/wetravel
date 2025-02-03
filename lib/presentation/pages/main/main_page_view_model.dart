import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/domain/entity/package.dart';
import 'package:wetravel/presentation/provider/package_provider.dart';

class MainPageState {
  final List<Package> recentPackages;
  const MainPageState({required this.recentPackages});
}

class MainPageViewModel extends Notifier<MainPageState> {
  @override
  MainPageState build() {
    fetchRecentPackages();
    return MainPageState(recentPackages: []);
  }

  /// 최근에 본 패키지 목록
  Future<void> fetchRecentPackages() async {
    try {
      final recentPackages =
          await ref.read(fetchRecentPackagesProvider).execute();
      state = MainPageState(recentPackages: recentPackages);
    } catch (e) {
      state = MainPageState(recentPackages: []);
    }
  }
}

final mainPageViewModel =
    NotifierProvider<MainPageViewModel, MainPageState>(() {
  return MainPageViewModel();
});
