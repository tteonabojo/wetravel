import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wetravel/domain/entity/banner.dart';
import 'package:wetravel/domain/repository/banner_repository.dart';
import 'package:wetravel/domain/usecase/fetch_banners_usecase.dart';

class MockBannerRepository extends Mock implements BannerRepository {}

void main() {
  late final MockBannerRepository mockBannerRepository;
  late final FetchBannersUsecase fetchBannersUsecase;
  setUp(
    () async {
      mockBannerRepository = MockBannerRepository();
      fetchBannersUsecase = FetchBannersUsecase(mockBannerRepository);
    },
  );

  test(
    'FetchBannersUsecase test : fetchBanners',
    () async {
      when(() => mockBannerRepository.fetchBanners())
          .thenAnswer((invocation) async => [
                Banner(
                  id: 'id',
                  linkUrl: 'linkUrl',
                  imageUrl: 'imageUrl',
                  startDate: Timestamp.now(),
                  endDate: Timestamp.now(),
                  isHidden: false,
                  company: 'company',
                  description: 'description',
                  order: 1,
                )
              ]);

      final result = await fetchBannersUsecase.execute();
      expect(result.length, 1);
      expect(result[0].company, 'company');
    },
  );
}
