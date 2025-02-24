import 'package:wetravel/domain/repository/package_repository.dart';

class AddPackageUseCase {
  final PackageRepository _repository;

  AddPackageUseCase(this._repository);

  Future<void> execute(Map<String, dynamic> packageData) {
    return _repository.addPackage(packageData);
  }
}
