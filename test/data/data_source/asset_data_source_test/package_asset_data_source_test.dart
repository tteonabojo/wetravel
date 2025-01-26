import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wetravel/data/data_source/data_source_implement/asset_data_source_impl/schedule_asset_data_source_impl.dart';

class MockAssetBundle extends Mock implements AssetBundle {}

void main() {
  late final MockAssetBundle mockAssetBundle;
  late final ScheduleAssetDataSourceImpl scheduleAssetDataSourceImpl;
  setUp(
    () async {
      mockAssetBundle = MockAssetBundle();
      scheduleAssetDataSourceImpl =
          ScheduleAssetDataSourceImpl(mockAssetBundle);
    },
  );

  test(
    'ScheduleAssetDataSourceImpl: fetchSchedules return data test',
    () async {
      // 가짜데이터 주입
      when(() => mockAssetBundle.loadString(any())).thenAnswer((_) async => """
  [{
      "id": "sch_1",
      "packageId": "pkg_1",
      "title": "제주공항 도착 & 렌터카 픽업",
      "content": "제주공항에 도착하여 렌터카를 픽업하고 숙소로 이동합니다.",
      "imageUrl": "https://picsum.photos/200/300",
      "order": 1
    }]
""");

      // 호출
      final result = await scheduleAssetDataSourceImpl.fetchSchedules();
      // 검증
      expect(result.length, 1);
    },
  );
}
