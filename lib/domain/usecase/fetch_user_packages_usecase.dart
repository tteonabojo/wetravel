import 'package:wetravel/domain/repository/package_repository.dart';
import 'package:wetravel/domain/entity/package.dart';

class FetchUserPackagesUseCase {
  final PackageRepository packageRepository;

  FetchUserPackagesUseCase(this.packageRepository);

  Future<List<Package>> execute(String userId) async {
    return await packageRepository.fetchPackagesByUserId(userId);
  }
}
