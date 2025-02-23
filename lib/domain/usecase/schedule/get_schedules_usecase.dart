import 'package:wetravel/domain/entity/schedule.dart';
import 'package:wetravel/domain/repository/schedule_repository.dart';

class GetSchedulesUsecase {
  GetSchedulesUsecase(this._scheduleRepository);
  final ScheduleRepository _scheduleRepository;

  Future<List<Schedule>> execute(List<String> scheduleIds) async {
    return await _scheduleRepository.fetchSchedules(scheduleIds);
  }
}
