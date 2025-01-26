import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wetravel/data/data_source/data_source_implement/asset_data_source_impl/user_asset_data_source_impl.dart';

class MockAssetBundle extends Mock implements AssetBundle {}

void main() {
  late final MockAssetBundle mockAssetBundle;
  late final UserAssetDataSourceImpl userAssetDataSourceImpl;
  setUp(
    () async {
      mockAssetBundle = MockAssetBundle();
      userAssetDataSourceImpl = UserAssetDataSourceImpl(mockAssetBundle);
    },
  );

  test(
    'UserAssetDataSourceImpl: fetchUsers return data test',
    () async {
      // 가짜데이터 주입
      when(() => mockAssetBundle.loadString(any())).thenAnswer((_) async => """
  [{
      "id": "1",
      "email": "user1@gmail.com",
      "password": "password123",
      "name": "User 1",
      "imageUrl": "https://picsum.photos/200/300",
      "introduction": "I am a software engineer who loves traveling and meeting new people.",
      "loginType": "EMAIL",
      "isGuide": false,
      "createdAt": "2023-01-01 00:00:00",
      "updatedAt": "2023-01-01 00:00:00",
      "deletedAt": null,
      "scrapList": []
    }]
""");

      // 호출
      final result = await userAssetDataSourceImpl.fetchUsers();
      // 검증
      expect(result.length, 1);
    },
  );
}
