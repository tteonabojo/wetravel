import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wetravel/data/data_source/data_source_implement/asset_data_source_impl/banner_asset_data_source_impl.dart';

class MockAssetBundle extends Mock implements AssetBundle {}

void main() {
  late final MockAssetBundle mockAssetBundle;
  late final BannerAssetDataSourceImpl bannerAssetDataSourceImpl;
  setUp(
    () async {
      mockAssetBundle = MockAssetBundle();
      bannerAssetDataSourceImpl = BannerAssetDataSourceImpl(mockAssetBundle);
    },
  );

  test(
    'BannerAssetDataSourceImpl: fetchBanners return data test',
    () async {
      // 가짜데이터 주입
      when(() => mockAssetBundle.loadString(any())).thenAnswer((_) async => """
  [{
      "id": "banner_1",
      "linkUrl": "https://picsum.photos/200/300",
      "imageUrl": "https://picsum.photos/200/300",
      "company": "Example Company 1",
      "description": "새로운 상품 출시!",
      "startDate": "2023-11-01T00:00:00Z",
      "endDate": "2023-11-30T23:59:59Z",
      "isHidden": false,
      "order": 1
    }]
""");

      // 호출
      final result = await bannerAssetDataSourceImpl.fetchBanners();
      // 검증
      expect(result.length, 1);
    },
  );
}
