import 'package:wetravel/domain/entity/travel_schedule.dart';

abstract class ScheduleDataSource {
  Future<void> saveSchedule(String userId, TravelSchedule schedule);
  Future<List<TravelSchedule>> fetchSchedules(String userId);
}
