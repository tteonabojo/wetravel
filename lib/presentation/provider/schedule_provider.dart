import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/data/data_source/data_source_implement/schedule_data_source_impl.dart';
import 'package:wetravel/data/data_source/schedule_data_source.dart';
import 'package:wetravel/data/repository/schedule_repository_impl.dart';
import 'package:wetravel/domain/repository/schedule_repository.dart';
import 'package:wetravel/domain/usecase/fetch_schedules_usecase.dart';

final _scheduleDataSourceProvider = Provider<ScheduleDataSource>((ref) {
  return ScheduleDataSourceImpl(FirebaseFirestore.instance);
});

final _scheduleRepositoryProvider = Provider<ScheduleRepository>(
  (ref) {
    final dataSource = ref.watch(_scheduleDataSourceProvider);
    return ScheduleRepositoryImpl(dataSource);
  },
);

final fetchSchedulesUsecaseProvider = Provider(
  (ref) {
    final scheduleRepo = ref.watch(_scheduleRepositoryProvider);
    return FetchSchedulesUsecase(scheduleRepo);
  },
);
