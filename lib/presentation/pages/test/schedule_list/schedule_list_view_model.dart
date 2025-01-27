import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/domain/entity/schedule.dart';
import 'package:wetravel/presentation/provider/schedule_provider.dart';

class ScheduleListViewModel extends Notifier<List<Schedule>?> {
  @override
  List<Schedule>? build() {
    fetchSchedules();
    return null;
  }

  Future<void> fetchSchedules() async {
    state = await ref.watch(fetchSchedulesUsecaseProvider).execute();
  }
}

final scheduleListViewModel =
    NotifierProvider<ScheduleListViewModel, List<Schedule>?>(
        () => ScheduleListViewModel());
