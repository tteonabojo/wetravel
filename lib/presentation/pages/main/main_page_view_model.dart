import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/domain/entity/package.dart';
import 'package:wetravel/presentation/provider/package_provider.dart';

class MainPageState {
  final List<Package> recentPackages;
  final List<Package> popularPackages;

  const MainPageState(
      {required this.recentPackages, required this.popularPackages});

  MainPageState copyWith({
    List<Package>? recentPackages,
    List<Package>? popularPackages,
  }) {
    return MainPageState(
      recentPackages: recentPackages ?? this.recentPackages,
      popularPackages: popularPackages ?? this.popularPackages,
    );
  }
}

class MainPageViewModel extends Notifier<MainPageState> {
  @override
  MainPageState build() {
    fetchPopularPackages();
    watchRecentPackages();
    // fetchRecentPackages();
    return MainPageState(recentPackages: [], popularPackages: []);
  }

  /// 최근에 본 패키지 목록
  Future<void> fetchRecentPackages() async {
    try {
      final recentPackages =
          await ref.read(fetchRecentPackagesProvider).execute();
      state = state.copyWith(recentPackages: recentPackages);
    } catch (e) {
      state = state.copyWith(recentPackages: []);
    }
  }

  /// 인기 있는 패키지 목록
  Future<void> fetchPopularPackages() async {
    try {
      final popularPackages =
          await ref.read(fetchPopularPackagesProvider).execute();
      state = state.copyWith(popularPackages: popularPackages);
    } catch (e) {
      state = state.copyWith(popularPackages: []);
    }
  }

  StreamSubscription? _streamSubscription;

  /// 최근에 본 패키지 목록
  void watchRecentPackages() {
    _streamSubscription?.cancel();
    _streamSubscription =
        ref.watch(watchRecentPackagesProvider).execute().listen(
              (packages) => state = state.copyWith(recentPackages: packages),
              onError: (e) => state = state.copyWith(recentPackages: []),
            );
  }
}

final mainPageViewModel =
    NotifierProvider<MainPageViewModel, MainPageState>(() {
  return MainPageViewModel();
});
