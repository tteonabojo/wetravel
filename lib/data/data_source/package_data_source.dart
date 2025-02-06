import 'package:wetravel/data/dto/package_dto.dart';

abstract interface class PackageDataSource {
  Future<List<PackageDto>> fetchPackages();

  Future<PackageDto> getPackageById(String packageId);

  Future<List<PackageDto>> fetchPackagesByUserId(
      String userId); // 특정 사용자에 대한 패키지 가져오기
  Future<void> addPackage(Map<String, dynamic> packageData);

  Future<Map<int, List<Map<String, String>>>> fetchSchedulesByIds(
      List<String> scheduleIds);

  /// 최근에 본 패키지 목록
  Future<List<PackageDto>> fetchRecentPackages();

  /// 인기 있는 패키지 목록
  Future<List<PackageDto>> fetchPopularPackages();

  /// 최근에 본 패키지 목록
  Stream<List<PackageDto>> watchRecentPackages();
}
