import 'dart:convert';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wetravel/data/data_source/user_data_source_impl.dart';

void main() {
  late final FakeFirebaseFirestore fakeFirebaseFirestore;
  late final UserDataSourceImpl userDataSourceImpl;
  setUp(
    () async {
      fakeFirebaseFirestore = FakeFirebaseFirestore();
      userDataSourceImpl = UserDataSourceImpl(fakeFirebaseFirestore);
      final collectionRef = fakeFirebaseFirestore.collection('user');
      final documentRef = collectionRef.doc('1');
      documentRef.set(jsonDecode("""
{
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
    }
"""));
    },
  );
  test(
    'UserDataSourceImpl : fetchUsers return data test',
    () async {
      final result = await userDataSourceImpl.fetchUsers();
      expect(result.length, 1);
    },
  );
}
