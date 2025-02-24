import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/domain/entity/package.dart';
import 'package:wetravel/domain/entity/schedule.dart';
import 'package:wetravel/domain/usecase/package/get_package_usecase.dart';
import 'package:wetravel/domain/usecase/schedule/get_schedules_usecase.dart';
import 'package:wetravel/presentation/provider/package_provider.dart';
import 'package:wetravel/presentation/provider/schedule_provider.dart';

class PackageDetailViewModel extends StateNotifier<PackageDetailState> {
  final GetPackageUseCase getPackageUseCase;
  final GetSchedulesUsecase getSchedulesUseCase;

  PackageDetailViewModel({
    required this.getPackageUseCase,
    required this.getSchedulesUseCase,
  }) : super(PackageDetailState.initial());

  Future<void> loadData(String packageId) async {
    try {
      final fetchedPackage = await getPackageUseCase.execute(packageId);
      final scheduleIdList = fetchedPackage?.scheduleIdList ?? [];
      if (scheduleIdList.isEmpty) throw Exception('No schedules available.');

      final schedules = await getSchedulesUseCase.execute(scheduleIdList);
      final scheduleMap = _groupSchedulesByDay(schedules);

      state = state.copyWith(
        package: fetchedPackage,
        scheduleMap: scheduleMap,
      );
    } catch (e) {
      log('Error loading data: $e');
    }
  }

  Map<int, List<Schedule>> _groupSchedulesByDay(List<Schedule> schedules) {
    final tempScheduleMap = <int, List<Schedule>>{};
    for (var schedule in schedules) {
      tempScheduleMap.putIfAbsent(schedule.day, () => []).add(schedule);
    }
    return tempScheduleMap;
  }
}

class PackageDetailState {
  final Package? package;
  final Map<int, List<Schedule>> scheduleMap;

  PackageDetailState({
    this.package,
    this.scheduleMap = const {},
  });

  factory PackageDetailState.initial() {
    return PackageDetailState();
  }

  PackageDetailState copyWith({
    Package? package,
    Map<int, List<Schedule>>? scheduleMap,
  }) {
    return PackageDetailState(
      package: package ?? this.package,
      scheduleMap: scheduleMap ?? this.scheduleMap,
    );
  }
}

final packageDetailViewModelProvider =
    StateNotifierProvider<PackageDetailViewModel, PackageDetailState>((ref) {
  return PackageDetailViewModel(
    getPackageUseCase: ref.read(getPackageUseCaseProvider),
    getSchedulesUseCase: ref.read(getSchedulesUseCaseProvider),
  );
});
