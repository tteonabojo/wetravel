import 'package:wetravel/domain/entity/schedule_entity.dart';
import 'package:wetravel/domain/repository/schedule_repository.dart';

class GetScheduleListUseCase {
  final ScheduleRepository scheduleRepository;

  GetScheduleListUseCase(this.scheduleRepository);

  Future<List<ScheduleEntity>> execute() async {
    return await scheduleRepository.getSchedules();
  }
}