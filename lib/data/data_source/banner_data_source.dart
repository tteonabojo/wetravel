import 'package:wetravel/data/dto/banner_dto.dart';

abstract interface class BannerDataSource {
  Future<List<BannerDto>> fetchBanners();
}
