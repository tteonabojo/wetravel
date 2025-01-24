import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wetravel/domain/entity/package.dart';
import 'package:wetravel/domain/repository/package_repository.dart';
import 'package:wetravel/domain/usecase/fetch_packages_usecase.dart';

class MockPackageRepository extends Mock implements PackageRepository {}

void main() {
  late final MockPackageRepository mockPackageRepository;
  late final FetchPackagesUsecase fetchPackagesUsecase;
  setUp(
    () async {
      mockPackageRepository = MockPackageRepository();
      fetchPackagesUsecase = FetchPackagesUsecase(mockPackageRepository);
    },
  );

  test(
    'FetchPackagesUsecase test : fetchPackages',
    () async {
      when(() => mockPackageRepository.fetchPackages())
          .thenAnswer((invocation) async => [
                Package(
                  id: 'id',
                  userId: 'userId',
                  title: 'title',
                  location: 'location',
                  description: 'description',
                  duration: 'duration',
                  imageUrl: 'imageUrl',
                  keywordList: [],
                  schedule: [],
                  createdAt: Timestamp.now(),
                  updatedAt: Timestamp.now(),
                )
              ]);

      final result = await fetchPackagesUsecase.execute();
      expect(result.length, 1);
      expect(result[0].location, 'location');
    },
  );
}
