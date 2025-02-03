import 'package:wetravel/data/data_source/schedule_data_source.dart';
import 'package:wetravel/domain/entity/schedule.dart';
import 'package:wetravel/domain/entity/travel_schedule.dart';
import 'package:wetravel/domain/repository/schedule_repository.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  ScheduleRepositoryImpl(this._scheduleDataSource);
  final ScheduleDataSource _scheduleDataSource;

  @override
  Future<List<Schedule>> fetchSchedules() async {
    // 임시로 빈 리스트 반환
    // TODO: 나중에 실제 Schedule 데이터를 가져오는 로직 구현
    return [];
  }

  @override
  Future<void> saveSchedule(String userId, TravelSchedule schedule) async {
    await _scheduleDataSource.saveSchedule(userId, schedule);
  }
}
