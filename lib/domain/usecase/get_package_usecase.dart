// domain/usecase/get_package_use_case.dart
import 'package:wetravel/domain/entity/package.dart';
import 'package:wetravel/domain/repository/package_repository.dart';

class GetPackageUseCase {
  final PackageRepository repository;

  GetPackageUseCase(this.repository);

  Future<Package> execute(String packageId) async {
    return await repository.fetchPackageData(packageId);
  }
}
