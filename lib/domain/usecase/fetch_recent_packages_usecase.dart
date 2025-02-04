import 'package:wetravel/domain/entity/package.dart';
import 'package:wetravel/domain/repository/package_repository.dart';

class FetchRecentPackagesUsecase {
  final PackageRepository _packageRepository;
  FetchRecentPackagesUsecase(this._packageRepository);

  Future<List<Package>> execute() async {
    return await _packageRepository.fetchRecentPackages();
  }
}
