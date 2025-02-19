import 'package:wetravel/domain/entity/schedule.dart';

abstract class ScheduleRepository {
  Stream<List<Schedule>> getSchedules(String userId);
  Future<void> saveSchedule(String userId, Schedule schedule);
  Future<List<Schedule>> fetchSchedules(List<String> scheduleIds);
}
