import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wetravel/domain/entity/schedule.dart';
import 'package:wetravel/domain/repository/schedule_repository.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final FirebaseFirestore _firestore;

  ScheduleRepositoryImpl(this._firestore);

  @override
  Stream<List<Schedule>> getSchedules(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('schedules')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Schedule.fromJson(doc.data())).toList());
  }

  @override
  Future<void> saveSchedule(String userId, Schedule schedule) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('schedules')
        .doc(schedule.id)
        .set(schedule.toJson());
  }

  @override
  Future<List<Schedule>> fetchSchedules(List<String> scheduleIds) async {
    final snapshots = await Future.wait(
      scheduleIds.map(
        (id) => _firestore.collection('schedules').doc(id).get(),
      ),
    );

    return snapshots
        .where((snapshot) => snapshot.exists)
        .map((snapshot) => Schedule.fromJson(snapshot.data()!))
        .toList();
  }
}
