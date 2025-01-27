import 'dart:convert';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wetravel/data/data_source/data_source_implement/schedule_data_source_impl.dart';

void main() {
  late final FakeFirebaseFirestore fakeFirebaseFirestore;
  late final ScheduleDataSourceImpl scheduleDataSourceImpl;
  setUp(() async {
    fakeFirebaseFirestore = FakeFirebaseFirestore();
    scheduleDataSourceImpl = ScheduleDataSourceImpl(fakeFirebaseFirestore);
    final collectionRef = fakeFirebaseFirestore.collection('schedules');
    final documentRef = collectionRef.doc('1');
    documentRef.set(jsonDecode("""
    {
    "id": "sch_1",
    "packageId": "pkg_1",
    "title": "제주공항 도착 & 렌터카 픽업",
    "content": "제주공항에 도착하여 렌터카를 픽업하고 숙소로 이동합니다.",
    "imageUrl": "https://picsum.photos/200/300",
    "order": 1
    }
    """));
  });

  test(
    'ScheduleDataSourceImpl : fetchSchedules return data test',
    () async {
      final result = await scheduleDataSourceImpl.fetchSchedules();
      expect(result.length, 1);
    },
  );
}
