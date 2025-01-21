import 'package:wetravel/domain/entity/banner_entity.dart';
import 'package:wetravel/domain/repository/banner_repository.dart';

class GetBannerListUseCase {
  final BannerRepository bannerRepository;

  GetBannerListUseCase(this.bannerRepository);

  Future<List<BannerEntity>> execute() async {
    return await bannerRepository.getBanners();
  }
}