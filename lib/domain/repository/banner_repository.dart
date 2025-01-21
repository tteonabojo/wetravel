import 'package:wetravel/domain/entity/banner_entity.dart';

abstract class BannerRepository {
  Future<List<BannerEntity>> getBanners();
}