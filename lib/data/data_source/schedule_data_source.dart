import 'package:wetravel/data/dto/schedule_dto.dart';

abstract interface class ScheduleDataSource {
  Future<List<ScheduleDto>> fetchSchedules();
}
