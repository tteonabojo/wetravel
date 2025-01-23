import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wetravel/data/data_source/user_asset_data_source_impl.dart';

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
    'UserAssetDataSourceImpl : fetchUsers return data test',
    () async {
      when(() => mockAssetBundle.loadString(any())).thenAnswer((_) async => """
{
      "id": "1",
      "email": "user1@gmail.com",
      "password": "password123",
      "name": "User 1",
      "imageUrl": "https://example.com/user1_image.jpg",
      "introduction": "I am a software engineer who loves traveling and meeting new people.",
      "loginType": "EMAIL",
      "isGuide": false,
      "createdAt": "2023-01-01 00:00:00",
      "updatedAt": "2023-01-01 00:00:00",
      "deletedAt": null,
      "scrapList": []
    }
""");

      final result = await userAssetDataSourceImpl.fetchUsers();
      expect(result.length, 1);
    },
  );
}
