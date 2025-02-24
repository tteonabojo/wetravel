import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/domain/entity/banner.dart';
import 'package:wetravel/domain/entity/package.dart';
import 'package:wetravel/domain/entity/user.dart';
import 'package:wetravel/presentation/provider/banner_provider.dart';
import 'package:wetravel/presentation/provider/package_provider.dart';
import 'package:wetravel/presentation/provider/user_provider.dart';

class MainPageState {
  final List<Package> recentPackages;
  final List<Package> popularPackages;
  final List<Banner> banners;
  final Map<String, User> userMap; // 최신화된 유저 정보

  const MainPageState({
    required this.recentPackages,
    required this.popularPackages,
    required this.banners,
    required this.userMap,
  });

  MainPageState copyWith({
    List<Package>? recentPackages,
    List<Package>? popularPackages,
    List<Banner>? banners,
    Map<String, User>? userMap,
  }) {
    return MainPageState(
      recentPackages: recentPackages ?? this.recentPackages,
      popularPackages: popularPackages ?? this.popularPackages,
      banners: banners ?? this.banners,
      userMap: userMap ?? this.userMap,
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
      userMap: {},
    );
  }

  StreamSubscription? _streamSubscription;

  Future<void> _fetchUserInfo(List<Package> packages) async {
    final existIds = state.userMap.entries.map((e) => e.key);

    final ids = packages
        .where((e) => !existIds.contains(e.userId))
        .map((e) => e.id)
        .toList();
    final results = await ref.read(fetchUsersByIdsUsecaseProvider).execute(ids);
    final newUserMap = state.userMap;
    for (var e in results) {
      newUserMap[e.id] = e;
    }
    state = state.copyWith(userMap: newUserMap);
  }

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
      await _fetchUserInfo(popularPackages);
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
      // 모든 데이터를 새로고침
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
      );
    } catch (e) {
      // 오류 발생 시 처리
      state = state.copyWith(
        banners: [],
        recentPackages: [],
        popularPackages: [],
      );
    }
  }
}

final mainPageViewModel =
    NotifierProvider.autoDispose<MainPageViewModel, MainPageState>(() {
  return MainPageViewModel();
});
