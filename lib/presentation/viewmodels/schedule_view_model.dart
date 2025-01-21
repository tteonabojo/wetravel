import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/domain/entity/schedule_entity.dart';
import 'package:wetravel/presentation/provider/schedule_provider.dart';

class ScheduleViewModel extends StateNotifier<AsyncValue<List<ScheduleEntity>>> {
  ScheduleViewModel(this._ref) : super(const AsyncValue.loading());

  final Ref _ref;

  Future<void> fetchSchedules() async {
    state = await _ref.refresh(scheduleProvider);
  }
}