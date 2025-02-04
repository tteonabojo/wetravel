import 'package:wetravel/domain/entity/package.dart';
import 'package:wetravel/domain/repository/package_repository.dart';

class FetchPopularPackagesUsecase {
  PackageRepository _packageRepository;
  FetchPopularPackagesUsecase(this._packageRepository);

  Future<List<Package>> execute() async {
    return await _packageRepository.fetchPopularPackages();
  }
}
