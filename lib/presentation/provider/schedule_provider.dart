import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/data/data_source/data_source_implement/schedule_data_source_impl.dart';
import 'package:wetravel/data/data_source/schedule_data_source.dart';
import 'package:wetravel/data/repository/schedule_repository_impl.dart';
import 'package:wetravel/domain/repository/schedule_repository.dart';
import 'package:wetravel/domain/usecase/fetch_schedules_usecase.dart';
import 'package:wetravel/domain/entity/survey_response.dart';
import 'package:wetravel/domain/entity/travel_schedule.dart';
import 'package:wetravel/presentation/provider/recommendation_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

final scheduleProvider = FutureProvider.autoDispose
    .family<TravelSchedule, SurveyResponse>((ref, survey) async {
  final geminiService = ref.read(geminiServiceProvider);
  final response = await geminiService.getTravelSchedule(survey);
  return TravelSchedule.fromGeminiResponse(response);
});

final selectedDayProvider = StateProvider.autoDispose<int>((ref) => 0);

final saveScheduleProvider =
    FutureProvider.autoDispose.family<void, TravelSchedule>(
  (ref, schedule) async {
    final scheduleRepo = ref.read(_scheduleRepositoryProvider);
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) throw Exception('User not logged in');
    await scheduleRepo.saveSchedule(userId, schedule);
  },
);
