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
    test('should return schedules on valid JSON', () async {
      // Arrange
      const jsonString = '''
      [
        {"id": "1", "title": "M", "date": "2025-01-23", "description": "D"},
        {"id": "2", "title": "C", "date": "2025-01-24", "description": "M"}
      ]
      ''';
      when(() => mockAssetBundle.loadString('assets/data/schedules.json'))
          .thenAnswer((_) async => jsonString);

      // Act
      final result = await dataSource.getSchedules();

      // Assert
      expect(result, hasLength(2));
      expect(result[0].id, "1");
      expect(result[0].title, "M");
    });

    test('should throw FormatException on invalid JSON', () async {
      // Arrange
      const invalidJson = '''
      [
        {"id": "1", "title": "M", "date": "2025-01-23"}
      ''';
      when(() => mockAssetBundle.loadString('assets/data/schedules.json'))
          .thenAnswer((_) async => invalidJson);

      // Act & Assert
      expect(() => dataSource.getSchedules(), throwsA(isA<FormatException>()));
    });

    test('should throw FlutterError when file not found', () async {
      // Arrange
      when(() => mockAssetBundle.loadString('assets/data/schedules.json'))
          .thenThrow(FlutterError('File not found'));

      // Act & Assert
      expect(() => dataSource.getSchedules(), throwsA(isA<FlutterError>()));
    });
  });
}
