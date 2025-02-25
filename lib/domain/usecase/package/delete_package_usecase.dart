import 'package:wetravel/domain/repository/package_repository.dart';

class DeletePackageUseCase {
  final PackageRepository packageRepository;

  DeletePackageUseCase({required this.packageRepository});

  Future<void> execute(String packageId) async {
    await packageRepository.deletePackage(packageId);
  }
}
