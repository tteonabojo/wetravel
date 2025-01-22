import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/domain/entity/schedule.dart';
import 'package:wetravel/presentation/provider/schedule_provider.dart';

class ScheduleViewModel extends StateNotifier<AsyncValue<List<Schedule>>> {
  ScheduleViewModel(this._ref) : super(const AsyncValue.loading());

  final Ref _ref;

  Future<void> fetchSchedules() async {
    state = await _ref.refresh(scheduleProvider);
  }
}
