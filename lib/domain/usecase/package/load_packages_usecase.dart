import 'package:wetravel/domain/repository/package_repository.dart';
import 'package:wetravel/domain/entity/package.dart';

class LoadPackagesUseCase {
  final PackageRepository packageRepository;

  LoadPackagesUseCase({required this.packageRepository});

  Future<List<Package>> execute() async {
    return await packageRepository.fetchPackages();
  }
}
