import 'package:wetravel/domain/entity/package.dart';

abstract interface class PackageRepository {
  Future<List<Package>> fetchPackages();
  Future<Package> fetchPackageData(String packageId);

  Future<List<Package>> fetchPackagesByUserId(
      String userId); // 특정 사용자에 대한 패키지 가져오기
  Future<void> addPackage(Map<String, dynamic> packageData);

  Future<Map<int, List<Map<String, String>>>> fetchSchedulesByIds(
      List<String> scheduleIds);

  /// 최근에 본 패키지 목록
  Future<List<Package>> fetchRecentPackages();

  /// 인기 있는 패키지 목록
  Future<List<Package>> fetchPopularPackages();

  /// 최근에 본 패키지 목록
  Stream<List<Package>> watchRecentPackages();
}
