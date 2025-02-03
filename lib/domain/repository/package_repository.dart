import 'package:wetravel/domain/entity/package.dart';

abstract interface class PackageRepository {
  Future<List<Package>> fetchPackages();
  Future<List<Package>> fetchPackagesByUserId(
      String userId); // 특정 사용자에 대한 패키지 가져오기
  Future<void> addPackage(Map<String, dynamic> packageData);
}
