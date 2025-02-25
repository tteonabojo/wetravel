import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io' show Platform;

mixin AdHandlingMixin<T extends StatefulWidget> on State<T> {
  RewardedAd? _rewardedAd;
  bool _isAdLoading = false;

  /// 광고 ID 설정
  String get _adUnitId => Platform.isAndroid
      ? 'ca-app-pub-5444380029598582/3444349489'
      : 'ca-app-pub-5444380029598582/6818185842';

  /// 보상형 광고 로드
  Future<void> loadRewardedAd() async {
    if (_isAdLoading) return;

    setState(() => _isAdLoading = true);

    try {
      await RewardedAd.load(
        adUnitId: _adUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: _handleAdLoaded,
          onAdFailedToLoad: _handleAdFailedToLoad,
        ),
      );
    } catch (e) {
      _handleAdError(e);
    }
  }

  /// 광고 로드 성공 처리
  void _handleAdLoaded(RewardedAd ad) {
    _rewardedAd = ad;
    setState(() => _isAdLoading = false);

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedAd = null;
        setState(() => _isAdLoading = false);
      },
    );
  }

  /// 광고 로드 실패 처리
  void _handleAdFailedToLoad(LoadAdError error) {
    _rewardedAd = null;
    setState(() => _isAdLoading = false);
  }

  /// 광고 에러 처리
  void _handleAdError(dynamic error) {
    _rewardedAd = null;
    setState(() => _isAdLoading = false);
  }

  /// 광고 표시
  Future<void> showRewardedAd() async {
    if (_isAdLoading) return;
    if (_rewardedAd == null) return;

    try {
      await _rewardedAd!.show(onUserEarnedReward: (_, reward) {});
    } catch (e) {
      debugPrint('광고 표시 중 오류 발생: $e');
    }
  }

  /// 광고 상태 확인
  bool get isAdLoading => _isAdLoading;
  bool get hasAd => _rewardedAd != null;

  void loadInterstitialAd({
    required Function(InterstitialAd) onAdLoaded,
    required Function(LoadAdError) onAdFailedToLoad,
  }) {
    InterstitialAd.load(
      adUnitId: _getInterstitialAdUnitId(),
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: onAdFailedToLoad,
      ),
    );
  }

  String _getInterstitialAdUnitId() {
    // 테스트 광고 ID 사용 (실제 앱에서는 실제 광고 ID로 교체)
    return 'ca-app-pub-3940256099942544/1033173712'; // 테스트 광고 ID
  }
}
