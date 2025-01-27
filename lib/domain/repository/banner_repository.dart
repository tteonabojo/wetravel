import 'package:wetravel/domain/entity/banner.dart';

abstract class BannerRepository {
  Future<List<Banner>> fetchBanners();
}
