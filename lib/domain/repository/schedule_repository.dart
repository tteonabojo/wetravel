import 'package:wetravel/domain/entity/schedule.dart';

abstract class ScheduleRepository {
  Future<List<Schedule>> getSchedules();
}
