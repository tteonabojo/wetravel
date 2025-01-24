import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wetravel/data/data_source/banner_asset_data_source_impl.dart';
import 'package:wetravel/data/dto/banner_dto.dart';

class MockAssetBundle extends Mock implements AssetBundle {}

void main() {
  late BannerAssetDataSourceImpl dataSource;
  late MockAssetBundle mockAssetBundle;

  setUp(() {
    mockAssetBundle = MockAssetBundle();
    dataSource = BannerAssetDataSourceImpl(assetBundle: mockAssetBundle);
  });

  group('BannerAssetDataSourceImpl', () {
    test('JSON 데이터가 유효할떄 BannerDto 리스트를 반환하도록 하는 확인작업', () async {
      const jsonString = '''
      [
        {
          "id": "1",
          "linkUrl": "https://example.com/1",
          "imageUrl": "https://example.com/banner1.jpg",
          "company": "속초해수욕장",
          "description": "광활하고 드넓은 바다를 느껴보세요",
          "startDate": "2025-01-01T00:00:00.000Z",
          "endDate": "2025-12-31T23:59:59.000Z",
          "isHidden": false,
          "order": 1
        }
      ]
      ''';
      when(() => mockAssetBundle.loadString('assets/data/banners.json'))
          .thenAnswer((_) async => jsonString);

      final result = await dataSource.getBanners();

      expect(result, isA<List<BannerDto>>());
      expect(result, hasLength(1));
      expect(result.first.id, '1');
    });

    test('JSON 데이터가 유효하지 않을 떄 FormatException가 나오도록 확인작업', () async {
      const invalidJsonString = '''
      [
        {
          "id": "1",
          "linkUrl": "https://example.com/1",
          "imageUrl": "https://example.com/banner1.jpg",
          "startDate": "2025-01-01T00:00:00.000Z",
          "endDate": "2025-12-31T23:59:59.000Z",
          "isHidden": false,
          "order": 1
      ''';
      when(() => mockAssetBundle.loadString('assets/data/banners.json'))
          .thenAnswer((_) async => invalidJsonString);

      expect(() => dataSource.getBanners(), throwsA(isA<FormatException>()));
    });

    test('파일을 찾을 수 없을 때 FlutterError가 나오는지 확인작업.', () async {
      when(() => mockAssetBundle.loadString('assets/data/banners.json'))
          .thenThrow(FlutterError('Unable to load asset'));

      expect(() => dataSource.getBanners(), throwsA(isA<FlutterError>()));
    });
  });
}
