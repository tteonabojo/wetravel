import 'package:wetravel/domain/entity/banner.dart';
import 'package:wetravel/domain/repository/banner_repository.dart';

class FetchBannersUsecase {
  FetchBannersUsecase(this._bannerRepository);
  final BannerRepository _bannerRepository;

  Future<List<Banner>> execute() async {
    return await _bannerRepository.fetchBanners();
  }
}
