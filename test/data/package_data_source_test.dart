import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wetravel/data/data_source/package_data_source_impl.dart';

class MockAssetBundle extends Mock implements AssetBundle {}

void main() {
  late final MockAssetBundle mockAssetBundle;
  late final PackageDataSourceImpl packageDataSourceImpl;
  setUp(
    () async {
      mockAssetBundle = MockAssetBundle();
      packageDataSourceImpl = PackageDataSourceImpl(mockAssetBundle);
    },
  );
  test(
    'PackageAssetDataSourceImpl : fetchUsers return data test',
    () async {
      when(() => mockAssetBundle.loadString(any())).thenAnswer((_) async => """
{
      "id": "pkg_1",
      "userId": "user_1",
      "title": "제주도 3박 4일 여행",
      "location": "제주도",
      "description": "푸른 바다와 아름다운 자연을 만끽하는 제주도 여행",
      "duration": "3박 4일",
      "imageUrl": "https://picsum.photos/200/300",
      "keywordList": ["제주도", "여행", "바다", "힐링"],
      "schedule": [],
      "createdAt": "2023-10-26T10:00:00Z",
      "updatedAt": "2023-10-26T10:00:00Z",
      "deletedAt": null,
      "reportCount": 0,
      "isHidden": false
    }
""");
      final result = await packageDataSourceImpl.fetchPackages();
      expect(result.length, 1);
    },
  );
}
