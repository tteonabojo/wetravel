import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/domain/entity/banner.dart';
import 'package:wetravel/presentation/provider/banner_provider.dart';

class BannerListViewModel extends Notifier<List<Banner>?> {
  @override
  List<Banner>? build() {
    fetchBanners();
    return null;
  }

  Future<void> fetchBanners() async {
    state = await ref.watch(fetchBannersUsecaseProvider).execute();
  }
}

final bannerListViewModel =
    NotifierProvider<BannerListViewModel, List<Banner>?>(
        () => BannerListViewModel());
