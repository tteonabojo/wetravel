import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wetravel/data/data_source/schedule_data_source.dart';
import 'package:wetravel/data/dto/schedule_dto.dart';
import 'package:wetravel/data/repository/schedule_repository_impl.dart';

class MockScheduleDataSource extends Mock implements ScheduleDataSource {}

void main() {
  late final MockScheduleDataSource mockScheduleDataSource;
  late final ScheduleRepositoryImpl scheduleRepositoryImpl;
  setUp(
    () async {
      mockScheduleDataSource = MockScheduleDataSource();
      scheduleRepositoryImpl = ScheduleRepositoryImpl(mockScheduleDataSource);
    },
  );
  test(
    "ScheduleRepositoryImpl test : fetchSchedules",
    () async {
      when(() => mockScheduleDataSource.fetchSchedules())
          .thenAnswer((_) async => [
                ScheduleDto(
                  id: 'id',
                  packageId: 'packageId',
                  title: 'title',
                  order: 1,
                  day: 1,
                  time: '',
                  location: '',
                )
              ]);
      final result = await scheduleRepositoryImpl.fetchSchedules();
      expect(result.length, 1);
      expect(result[0].title, 'title');
    },
  );
}
