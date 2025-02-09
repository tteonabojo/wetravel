import 'package:wetravel/domain/entity/schedule.dart';
import 'package:wetravel/domain/entity/travel_schedule.dart';

abstract class ScheduleRepository {
  Future<List<Schedule>> fetchSchedules(List<String> scheduleIds);

  Future<void> saveSchedule(String userId, TravelSchedule schedule);
}
