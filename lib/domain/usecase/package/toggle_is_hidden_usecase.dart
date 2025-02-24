import 'package:wetravel/domain/repository/package_repository.dart';

class ToggleIsHiddenUseCase {
  final PackageRepository packageRepository;

  ToggleIsHiddenUseCase({required this.packageRepository});

  Future<void> execute(String packageId, bool currentStatus) async {
    await packageRepository.toggleIsHidden(packageId, currentStatus);
  }
}
