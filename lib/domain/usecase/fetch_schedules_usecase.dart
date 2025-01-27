import 'package:wetravel/domain/entity/schedule.dart';
import 'package:wetravel/domain/repository/schedule_repository.dart';

class FetchSchedulesUsecase {
  FetchSchedulesUsecase(this._scheduleRepository);
  final ScheduleRepository _scheduleRepository;

  Future<List<Schedule>> execute() async {
    return await _scheduleRepository.fetchSchedules();
  }
}
