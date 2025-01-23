import 'package:wetravel/data/data_source/package_data_source.dart';
import 'package:wetravel/domain/entity/package.dart';
import 'package:wetravel/domain/entity/schedule.dart';
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
              schedule: e.schedule
                  ?.map((schedule) => Schedule(
                        id: schedule.id,
                        packageId: schedule.packageId,
                        title: schedule.title,
                        content: schedule.content,
                        imageUrl: schedule.imageUrl,
                        order: schedule.order as int, // 기본값 설정
                      ))
                  .toList(),
              createdAt: e.createdAt,
              updatedAt: e.updatedAt,
            ))
        .toList();
  }
}
