import 'dart:convert';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wetravel/data/data_source/data_source_implement/banner_data_source_impl.dart';

void main() {
  late final FakeFirebaseFirestore fakeFirebaseFirestore;
  late final BannerDataSourceImpl bannerDataSourceImpl;
  setUp(() async {
    fakeFirebaseFirestore = FakeFirebaseFirestore();
    bannerDataSourceImpl = BannerDataSourceImpl(fakeFirebaseFirestore);
    final collectionRef = fakeFirebaseFirestore.collection('banners');
    final documentRef = collectionRef.doc('1');
    documentRef.set(jsonDecode('''
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
      '''));
  });

  test('BannerDataSourceImpl : fetchBanners return data test', () async {
    final result = await bannerDataSourceImpl.fetchBanners();
    expect(result.length, 1);
  });
}
