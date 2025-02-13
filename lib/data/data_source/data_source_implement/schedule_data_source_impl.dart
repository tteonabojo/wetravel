import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wetravel/core/constants/firestore_constants.dart';
import 'package:wetravel/data/data_source/schedule_data_source.dart';
import 'package:wetravel/data/dto/schedule_dto.dart';
import 'package:wetravel/domain/entity/travel_schedule.dart';

class ScheduleDataSourceImpl extends FirestoreConstants
    implements ScheduleDataSource {
  final FirebaseFirestore _firestore;

  ScheduleDataSourceImpl(this._firestore);

  @override
  Future<void> saveSchedule(String userId, TravelSchedule schedule) async {
    print(usersCollection);
    print(schedulesCollection);
    try {
      await _firestore
          .collection(usersCollection)
          .doc(userId)
          .collection(schedulesCollection)
          .add({
        'destination': schedule.destination,
        'createdAt': FieldValue.serverTimestamp(),
        'days': schedule.days
            .map((day) => {
                  'schedules': day.schedules
                      .map((item) => {
                            'time': item.time,
                            'title': item.title,
                            'location': item.location,
                          })
                      .toList(),
                })
            .toList(),
      });
    } catch (e) {
      throw Exception('Failed to save schedule: $e');
    }
  }

  @override
  Future<List<ScheduleDto>> getSchedulesByIds(List<String> scheduleIds) async {
    final schedules = <ScheduleDto>[];

    for (var scheduleId in scheduleIds) {
      final scheduleSnapshot =
          await _firestore.collection('schedules').doc(scheduleId).get();
      if (scheduleSnapshot.exists) {
        final data = scheduleSnapshot.data()!;
        schedules.add(ScheduleDto.fromJson(data));
      }
    }
    return schedules;
  }

  @override
  Future<List<TravelSchedule>> fetchSchedules(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('schedules')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return TravelSchedule.fromFirestore(data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch schedules: $e');
    }
  }
}
