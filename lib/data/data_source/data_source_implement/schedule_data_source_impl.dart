import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wetravel/data/data_source/schedule_data_source.dart';
import 'package:wetravel/data/dto/schedule_dto.dart';

class ScheduleDataSourceImpl implements ScheduleDataSource {
  ScheduleDataSourceImpl(this._firestore);
  final FirebaseFirestore _firestore;

  @override
  Future<List<ScheduleDto>> fetchSchedules() async {
    FirebaseFirestore firestore = _firestore;
    final collectionRef = firestore.collection('schedules');
    final snapshot = await collectionRef.get();
    final documentSnapshot = snapshot.docs;
    for (var docSnapshot in documentSnapshot) {
      print(docSnapshot.id);
      print(docSnapshot.data());
    }
    return documentSnapshot.map((e) => ScheduleDto.fromJson(e.data())).toList();
  }
}
