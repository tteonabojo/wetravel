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
  final bool isLoading;

  const MainPageState({
    required this.recentPackages,
    required this.popularPackages,
    required this.banners,
    this.isLoading = false,
  });

  MainPageState copyWith({
    List<Package>? recentPackages,
    List<Package>? popularPackages,
    List<Banner>? banners,
    bool? isLoading,
  }) {
    return MainPageState(
      recentPackages: recentPackages ?? this.recentPackages,
      popularPackages: popularPackages ?? this.popularPackages,
      banners: banners ?? this.banners,
      isLoading: isLoading ?? this.isLoading,
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
      isLoading: true,
    );
  }

  StreamSubscription? _streamSubscription;

  /// 최근에 본 패키지 목록
  void watchRecentPackages() {
    _streamSubscription?.cancel();
    _streamSubscription =
        ref.watch(watchRecentPackagesProvider).execute().listen(
              (packages) => state = state.copyWith(
                recentPackages: packages,
                isLoading: false,
              ),
              onError: (e) => state = state.copyWith(
                recentPackages: [],
                isLoading: false,
              ),
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

  /// 데이터 새로고침 메서드
  Future<void> refreshData() async {
    try {
      final freshBanners =
          await ref.read(fetchBannersUsecaseProvider).execute();
      final freshRecentPackages =
          await ref.read(watchRecentPackagesProvider).execute().first;
      final freshPopularPackages =
          await ref.read(fetchPopularPackagesProvider).execute();

      state = state.copyWith(
        banners: freshBanners,
        recentPackages: freshRecentPackages,
        popularPackages: freshPopularPackages,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        banners: [],
        recentPackages: [],
        popularPackages: [],
        isLoading: false,
      );
    }
  }
}

final mainPageViewModel =
    NotifierProvider.autoDispose<MainPageViewModel, MainPageState>(() {
  return MainPageViewModel();
});
