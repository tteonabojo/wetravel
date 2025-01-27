import 'package:wetravel/data/data_source/schedule_data_source.dart';
import 'package:wetravel/domain/entity/schedule.dart';
import 'package:wetravel/domain/repository/schedule_repository.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  ScheduleRepositoryImpl(this._scheduleDataSource);
  final ScheduleDataSource _scheduleDataSource;

  @override
  Future<List<Schedule>> fetchSchedules() async {
    final result = await _scheduleDataSource.fetchSchedules();
    return result
        .map((e) => Schedule(
              id: e.id,
              packageId: e.packageId,
              title: e.title,
              content: e.content,
              imageUrl: e.imageUrl,
              order: e.order,
            ))
        .toList();
  }
}
