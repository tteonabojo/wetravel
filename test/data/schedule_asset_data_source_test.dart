import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wetravel/data/data_source/schedule_asset_data_source_impl.dart';
import 'package:wetravel/data/dto/schedule_dto.dart';

class MockAssetBundle extends Mock implements AssetBundle {}

void main() {
  late ScheduleAssetDataSourceImpl dataSource;
  late MockAssetBundle mockAssetBundle;

  setUp(() {
    mockAssetBundle = MockAssetBundle();
    dataSource = ScheduleAssetDataSourceImpl(assetBundle: mockAssetBundle);
  });

  group('ScheduleAssetDataSourceImpl', () {
    test('JSON이 유효할떄 스케쥴을 반환하도록 하는 확인작업', () async {
      const jsonString = '''
      [
        {"id": "1", "title": "M", "date": "2025-01-23", "description": "D"},
        {"id": "2", "title": "C", "date": "2025-01-24", "description": "M"}
      ]
      ''';
      when(() => mockAssetBundle.loadString('assets/data/schedules.json'))
          .thenAnswer((_) async => jsonString);

      final result = await dataSource.getSchedules();

      expect(result, hasLength(2));
      expect(result[0].id, "1");
      expect(result[0].title, "M");
    });

    test('잘못된 JSON일 경우 FormatException가 나오도록 확인', () async {
      const invalidJson = '''
      [
        {"id": "1", "title": "M", "date": "2025-01-23"}
      ''';
      when(() => mockAssetBundle.loadString('assets/data/schedules.json'))
          .thenAnswer((_) async => invalidJson);

      expect(() => dataSource.getSchedules(), throwsA(isA<FormatException>()));
    });

    test('파일을 찾을 수 없는 경우 FlutterError가 나오도록 확인', () async {
      when(() => mockAssetBundle.loadString('assets/data/schedules.json'))
          .thenThrow(FlutterError('File not found'));

      expect(() => dataSource.getSchedules(), throwsA(isA<FlutterError>()));
    });
  });
}
