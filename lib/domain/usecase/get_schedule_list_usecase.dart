import 'package:wetravel/domain/entity/schedule.dart';
import 'package:wetravel/domain/repository/schedule_repository.dart';

class GetScheduleListUseCase {
  final ScheduleRepository scheduleRepository;

  GetScheduleListUseCase(this.scheduleRepository);

  Future<List<Schedule>> execute() async {
    return await scheduleRepository.getSchedules();
  }
}
