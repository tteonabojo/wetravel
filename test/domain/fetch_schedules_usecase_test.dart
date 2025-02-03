import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wetravel/domain/entity/schedule.dart';
import 'package:wetravel/domain/repository/schedule_repository.dart';
import 'package:wetravel/domain/usecase/fetch_schedules_usecase.dart';

class MockScheduleRepository extends Mock implements ScheduleRepository {}

void main() {
  late final MockScheduleRepository mockScheduleRepository;
  late final FetchSchedulesUsecase fetchSchedulesUsecase;
  setUp(
    () async {
      mockScheduleRepository = MockScheduleRepository();
      fetchSchedulesUsecase = FetchSchedulesUsecase(mockScheduleRepository);
    },
  );

  test(
    'FetchSchedulesUsecase test : fetchSchedules',
    () async {
      when(() => mockScheduleRepository.fetchSchedules())
          .thenAnswer((invocation) async => [
                Schedule(
                  id: 'id',
                  packageId: 'packageId',
                  title: 'title',
                  content: 'content',
                  imageUrl: 'imageUrl',
                  order: 1,
                  day: 1,
                  time: '',
                  location: '',
                )
              ]);

      final result = await fetchSchedulesUsecase.execute();
      expect(result.length, 1);
      expect(result[0].title, 'title');
    },
  );
}
