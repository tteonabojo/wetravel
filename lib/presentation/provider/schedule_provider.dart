import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/domain/entity/schedule.dart';
import 'package:wetravel/data/repository/schedule_repository_impl.dart';

final scheduleProvider = FutureProvider<List<Schedule>>((ref) async {
  final repository = ref.watch(scheduleRepositoryProvider);
  return await repository.getSchedules();
});

final scheduleRepositoryProvider =
    Provider<ScheduleRepositoryImpl>((ref) => ScheduleRepositoryImpl(
          dio: Dio(), // Dio 인스턴스 생성
        ));
