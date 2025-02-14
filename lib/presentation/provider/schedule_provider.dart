import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/data/data_source/data_source_implement/schedule_data_source_impl.dart';
import 'package:wetravel/data/data_source/schedule_data_source.dart';
import 'package:wetravel/data/repository/schedule_repository_impl.dart';
import 'package:wetravel/domain/repository/schedule_repository.dart';
import 'package:wetravel/domain/usecase/get_schedules_usecase.dart';
import 'package:wetravel/domain/entity/survey_response.dart';
import 'package:wetravel/domain/entity/travel_schedule.dart';
import 'package:wetravel/presentation/provider/recommendation_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wetravel/data/data_source/scrap_packages_data_source.dart';
import 'package:wetravel/data/data_source/data_source_implement/scrap_packages_data_source_impl.dart';

// FirebaseFirestore provider
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final _scheduleDataSourceProvider = Provider<ScheduleDataSource>((ref) {
  return ScheduleDataSourceImpl(FirebaseFirestore.instance);
});

final _scheduleRepositoryProvider = Provider<ScheduleRepository>(
  (ref) {
    final firestore = ref.watch(firestoreProvider);
    final dataSource = ref.watch(_scheduleDataSourceProvider);
    return ScheduleRepositoryImpl(firestore, dataSource);
  },
);

final fetchSchedulesUsecaseProvider = Provider(
  (ref) {
    final scheduleRepo = ref.watch(_scheduleRepositoryProvider);
    return GetSchedulesUsecase(scheduleRepo);
  },
);

final getSchedulesUseCaseProvider = Provider((ref) {
  final scheduleRepository = ref.read(_scheduleRepositoryProvider);
  return GetSchedulesUsecase(scheduleRepository);
});

final scheduleProvider = FutureProvider.autoDispose
    .family<TravelSchedule, SurveyResponse>((ref, survey) async {
  final geminiService = ref.read(geminiServiceProvider);
  final response = await geminiService.getTravelSchedule(survey);
  final travelSchedule = TravelSchedule.fromGeminiResponse(response);

  // 환경에 따른 저장소 구분
  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId != null) {
    final scheduleRepo = ref.read(_scheduleRepositoryProvider);
    final schedule =
        travelSchedule.toSchedule(); // TravelSchedule을 Schedule로 변환
    await scheduleRepo.saveSchedule(userId, schedule);
  }

  return travelSchedule;
});

final selectedDayProvider = StateProvider.autoDispose<int>((ref) => 0);

final saveScheduleProvider =
    FutureProvider.autoDispose.family<void, TravelSchedule>(
  (ref, travelSchedule) async {
    final scheduleRepo = ref.read(_scheduleRepositoryProvider);
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) throw Exception('User not logged in');

    final schedule =
        travelSchedule.toSchedule(); // TravelSchedule을 Schedule로 변환
    await scheduleRepo.saveSchedule(userId, schedule);
  },
);

final scrapPackagesDataSourceProvider =
    Provider<ScrapPackagesDataSource>((ref) {
  return ScrapPackagesDataSourceImpl(FirebaseFirestore.instance);
});

final scrapPackagesStreamProvider =
    StreamProvider<List<Map<String, dynamic>>>((ref) {
  final dataSource = ref.watch(scrapPackagesDataSourceProvider);
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value([]);
  return dataSource.getScrapPackages(user.uid);
});
