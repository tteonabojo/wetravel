import 'package:wetravel/data/data_source/schedule_data_source.dart';
import 'package:wetravel/domain/entity/schedule.dart';
import 'package:wetravel/domain/entity/travel_schedule.dart';
import 'package:wetravel/domain/repository/schedule_repository.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  ScheduleRepositoryImpl(this._scheduleDataSource);
  final ScheduleDataSource _scheduleDataSource;

  @override
  Future<List<Schedule>> fetchSchedules(List<String> scheduleIds) async {
    final scheduleDtos =
        await _scheduleDataSource.getSchedulesByIds(scheduleIds);
    return scheduleDtos
        .map((dto) => Schedule.fromDto(dto))
        .toList(); // DTO를 Entity로 변환
  }

  @override
  Future<void> saveSchedule(String userId, TravelSchedule schedule) async {
    await _scheduleDataSource.saveSchedule(userId, schedule);
  }
}
