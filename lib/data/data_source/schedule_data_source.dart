import 'package:wetravel/data/dto/schedule_dto.dart';
import 'package:wetravel/domain/entity/travel_schedule.dart';

abstract class ScheduleDataSource {
  Future<void> saveSchedule(String userId, TravelSchedule schedule);
  Future<List<TravelSchedule>> fetchSchedules(String userId);
  Future<List<ScheduleDto>> getSchedulesByIds(List<String> scheduleIds);
  Future<void> saveAISchedule(
      String userId, Map<String, dynamic> aiScheduleData);

  Stream<List<Map<String, dynamic>>> watchSchedules(String uid);
}
