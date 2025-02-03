import 'package:wetravel/data/data_source/package_data_source.dart';
import 'package:wetravel/domain/entity/package.dart';
import 'package:wetravel/domain/repository/package_repository.dart';

class PackageRepositoryImpl implements PackageRepository {
  PackageRepositoryImpl(this._packageDataSource);
  final PackageDataSource _packageDataSource;

  @override
  Future<List<Package>> fetchPackages() async {
    final result = await _packageDataSource.fetchPackages();
    return result
        .map((e) => Package(
              id: e.id,
              userId: e.userId,
              title: e.title,
              location: e.location,
              description: e.description,
              duration: e.duration,
              imageUrl: e.imageUrl,
              keywordList: e.keywordList,
              scheduleIdList: e.scheduleIdList,
              createdAt: e.createdAt,
              updatedAt: e.updatedAt,
              deletedAt: e.deletedAt,
              reportCount: e.reportCount,
              isHidden: e.isHidden,
            ))
        .toList();
  }

  @override
  Future<void> addPackage(Map<String, dynamic> packageData) {
    return _packageDataSource.addPackage(packageData);
  }

  @override
  Future<List<Package>> fetchPackagesByUserId(String userId) async {
    final result = await _packageDataSource.fetchPackagesByUserId(userId);
    return result
        .map((e) => Package(
              id: e.id,
              userId: e.userId,
              title: e.title,
              location: e.location,
              description: e.description,
              duration: e.duration,
              imageUrl: e.imageUrl,
              keywordList: e.keywordList,
              scheduleIdList: e.scheduleIdList,
              createdAt: e.createdAt,
              updatedAt: e.updatedAt,
              deletedAt: e.deletedAt,
              reportCount: e.reportCount,
              isHidden: e.isHidden,
            ))
        .toList();
  }
}
