import 'package:wetravel/domain/entity/package.dart';
import 'package:wetravel/domain/repository/package_repository.dart';

class WatchRecentPackagesUsecase {
  final PackageRepository _packageRepository;
  WatchRecentPackagesUsecase(this._packageRepository);

  Stream<List<Package>> execute() async* {
    yield* _packageRepository.watchRecentPackages();
  }
}
