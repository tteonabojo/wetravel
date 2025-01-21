import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/domain/entity/banner_entity.dart';
import 'package:wetravel/presentation/provider/banner_provider.dart';

class BannerViewModel extends StateNotifier<AsyncValue<List<BannerEntity>>> {
  BannerViewModel(this._ref) : super(const AsyncValue.loading());

  final Ref _ref;

  Future<void> fetchBanners() async {
    state = await _ref.refresh(bannerProvider);
  }
}