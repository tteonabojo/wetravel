import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wetravel/data/data_source/package_data_source.dart';
import 'package:wetravel/data/dto/package_dto.dart';
import 'package:wetravel/data/repository/package_repository_impl.dart';

class MockPackageDataSource extends Mock implements PackageDataSource {}

void main() {
  late final MockPackageDataSource mockPackageDataSource;
  late final PackageRepositoryImpl packageRepositoryImpl;
  setUp(
    () async {
      mockPackageDataSource = MockPackageDataSource();
      packageRepositoryImpl = PackageRepositoryImpl(mockPackageDataSource);
    },
  );
  test(
    "PackageRepositoryImpl test : fetchPackages",
    () async {
      when(() => mockPackageDataSource.fetchPackages())
          .thenAnswer((_) async => [
                PackageDto(
                  id: 'id',
                  userId: 'userId',
                  title: 'title',
                  location: 'location',
                  description: 'description',
                  duration: 'duration',
                  imageUrl: 'imageUrl',
                  keywordList: [],
                  schedule: [],
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                )
              ]);
      final result = await packageRepositoryImpl.fetchPackages();
      expect(result.length, 1);
    },
  );
}
