import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/domain/entity/banner.dart';
import 'package:wetravel/domain/entity/package.dart';
import 'package:wetravel/presentation/provider/banner_provider.dart';
import 'package:wetravel/presentation/provider/package_provider.dart';

class MainPageState {
  final List<Package> recentPackages;
  final List<Package> popularPackages;
  final List<Banner> banners;

  const MainPageState({
    required this.recentPackages,
    required this.popularPackages,
    required this.banners,
  });

  MainPageState copyWith({
    List<Package>? recentPackages,
    List<Package>? popularPackages,
    List<Banner>? banners,
  }) {
    return MainPageState(
      recentPackages: recentPackages ?? this.recentPackages,
      popularPackages: popularPackages ?? this.popularPackages,
      banners: banners ?? this.banners,
    );
  }
}

class MainPageViewModel extends AutoDisposeNotifier<MainPageState> {
  @override
  MainPageState build() {
    watchRecentPackages();
    fetchPopularPackages();
    fetchBanners();
    return MainPageState(
      recentPackages: [],
      popularPackages: [],
      banners: [],
    );
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

  /// 배너 목록
  Future<void> fetchBanners() async {
    try {
      final banners = await ref.read(fetchBannersUsecaseProvider).execute();
      state = state.copyWith(banners: banners);
    } catch (e) {
      state = state.copyWith(banners: []);
    }
  }
}

final mainPageViewModel =
    NotifierProvider.autoDispose<MainPageViewModel, MainPageState>(() {
  return MainPageViewModel();
});
