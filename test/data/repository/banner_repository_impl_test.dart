import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wetravel/data/data_source/banner_data_source.dart';
import 'package:wetravel/data/dto/banner_dto.dart';
import 'package:wetravel/data/repository/banner_repository_impl.dart';

class MockBannerDataSource extends Mock implements BannerDataSource {}

void main() {
  late final MockBannerDataSource mockBannerDataSource;
  late final BannerRepositoryImpl bannerRepositoryImpl;
  setUp(
    () async {
      mockBannerDataSource = MockBannerDataSource();
      bannerRepositoryImpl = BannerRepositoryImpl(mockBannerDataSource);
    },
  );
  test(
    "BannerRepositoryImpl test : fetchBanners",
    () async {
      when(() => mockBannerDataSource.fetchBanners()).thenAnswer((_) async => [
            BannerDto(
              id: 'id',
              linkUrl: 'linkUrl',
              imageUrl: 'imageUrl',
              company: 'company',
              description: 'description',
              startDate: Timestamp.now(),
              endDate: Timestamp.now(),
              isHidden: false,
              order: 1,
            )
          ]);
      final result = await bannerRepositoryImpl.fetchBanners();
      expect(result.length, 1);
      expect(result[0].company, 'company');
    },
  );
}
