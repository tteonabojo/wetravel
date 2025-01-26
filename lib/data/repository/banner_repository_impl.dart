import 'package:wetravel/data/data_source/banner_data_source.dart';
import 'package:wetravel/domain/entity/banner.dart';
import 'package:wetravel/domain/repository/banner_repository.dart';

class BannerRepositoryImpl implements BannerRepository {
  BannerRepositoryImpl(this._bannerDataSource);
  final BannerDataSource _bannerDataSource;

  @override
  Future<List<Banner>> fetchBanners() async {
    final result = await _bannerDataSource.fetchBanners();
    return result
        .map((e) => Banner(
              id: e.id,
              linkUrl: e.linkUrl,
              imageUrl: e.imageUrl,
              startDate: e.startDate,
              endDate: e.endDate,
              isHidden: e.isHidden,
              company: e.company,
              description: e.description,
              order: e.order,
            ))
        .toList();
  }
}
