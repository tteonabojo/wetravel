import 'package:wetravel/domain/entity/banner.dart';
import 'package:wetravel/domain/repository/banner_repository.dart';

class GetBannerListUseCase {
  final BannerRepository bannerRepository;

  GetBannerListUseCase(this.bannerRepository);

  Future<List<Banner>> execute() async {
    return await bannerRepository.getBanners();
  }
}
