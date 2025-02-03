import 'package:wetravel/data/dto/package_dto.dart';

abstract interface class PackageDataSource {
  Future<List<PackageDto>> fetchPackages();
  Future<List<PackageDto>> fetchPackagesByUserId(
      String userId); // 특정 사용자에 대한 패키지 가져오기
  Future<void> addPackage(Map<String, dynamic> packageData);
}
