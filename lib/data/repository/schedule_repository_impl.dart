import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wetravel/core/constants/firestore_constants.dart';
import 'package:wetravel/data/data_source/schedule_data_source.dart';
import 'package:wetravel/domain/entity/schedule.dart';
import 'package:wetravel/domain/repository/schedule_repository.dart';

class ScheduleRepositoryImpl extends FirestoreConstants
    implements ScheduleRepository {
  final FirebaseFirestore _firestore;
  final ScheduleDataSource _scheduleDataSource;

  ScheduleRepositoryImpl(this._firestore, this._scheduleDataSource);

  @override
  Stream<List<Schedule>> getSchedules(String userId) {
    return _firestore
        .collection(usersCollection)
        .doc(userId)
        .collection(schedulesCollection)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Schedule.fromJson(doc.data())).toList());
  }

  @override
  Future<void> saveSchedule(String userId, Schedule schedule) async {
    await _firestore
        .collection(usersCollection)
        .doc(userId)
        .collection(schedulesCollection)
        .doc(schedule.id)
        .set(schedule.toJson());
  }

  @override
  Future<List<Schedule>> fetchSchedules(List<String> scheduleIds) async {
    final scheduleDtos =
        await _scheduleDataSource.getSchedulesByIds(scheduleIds);
    return scheduleDtos
        .map((dto) => Schedule.fromJson(dto.toJson()))
        .toList(); // DTO를 Entity로 변환
  }
}
