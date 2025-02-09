import 'package:wetravel/domain/repository/package_repository.dart';

class FetchPackageSchedulesUsecase {
  final PackageRepository repository;
  FetchPackageSchedulesUsecase(this.repository);

  Future<Map<int, List<Map<String, String>>>> execute(
      List<String> scheduleIds) {
    return repository.fetchSchedulesByIds(scheduleIds);
  }
}
