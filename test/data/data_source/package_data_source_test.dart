import 'dart:convert';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wetravel/data/data_source/data_source_implement/package_data_source_impl.dart';

void main() {
  late final FakeFirebaseFirestore fakeFirebaseFirestore;
  late final PackageDataSourceImpl packageDataSourceImpl;
  setUp(
    () async {
      fakeFirebaseFirestore = FakeFirebaseFirestore();
      packageDataSourceImpl = PackageDataSourceImpl(fakeFirebaseFirestore);
      final collectionRef = fakeFirebaseFirestore.collection('packages');
      final documentRef = collectionRef.doc('1');
      documentRef.set(jsonDecode("""
{
      "id": "1",
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
"""));
    },
  );
  test(
    'PackageDataSourceImpl : fetchUser return data test',
    () async {
      final result = await packageDataSourceImpl.fetchPackages();
      expect(result.length, 1);
    },
  );
}
