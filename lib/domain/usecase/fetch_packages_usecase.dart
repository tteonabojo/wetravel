import 'package:wetravel/domain/entity/package.dart';
import 'package:wetravel/domain/repository/package_repository.dart';

class FetchPackagesUsecase {
  FetchPackagesUsecase(this._packageRepository);
  final PackageRepository _packageRepository;

  Future<List<Package>> execute() async {
    return await _packageRepository.fetchPackages();
  }
}
