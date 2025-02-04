import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PackageRegisterService {
  Future<void> registerPackage({
    required String title,
    required String location,
    required String description,
    required String duration,
    required String imageUrl,
    required List<String> keywordList,
    required List<Map<String, dynamic>> scheduleList,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('로그인한 사용자 정보를 찾을 수 없습니다.');
    }

    // 패키지 ID 생성
    final packageRef = FirebaseFirestore.instance.collection('packages').doc();
    final packageId = packageRef.id;

    // 스케줄 문서 리스트 저장
    List<String> scheduleIdList = [];
    try {
      // 일정들 (scheduleList)을 schedules 컬렉션에 각각 저장
      for (Map schedule in scheduleList) {
        // scheduleId를 packageId를 접두사로 붙여서 생성
        final scheduleRef = FirebaseFirestore.instance.collection('schedules').doc(
            '$packageId-${DateTime.now().millisecondsSinceEpoch}'); // 예시: "packageId-timestamp"

        final scheduleData = {
          'id': scheduleRef.id, // 문서 ID는 Firestore에서 자동으로 생성된 값
          'packageId': packageId,
          'day': schedule['day'],
          'time': schedule['time'],
          'title': schedule['title'],
          'location': schedule['location'],
          'content': schedule['content'],
          'imageUrl': schedule['imageUrl'],
          'order': schedule['order'],
        };

        await scheduleRef.set(scheduleData);

        // 생성된 scheduleId를 리스트에 추가
        scheduleIdList.add(scheduleRef.id);
      }

      // 패키지 데이터 저장
      final packageData = {
        'id': packageId,
        'userId': currentUser.uid,
        'title': title,
        'location': location,
        'description': description,
        'duration': duration,
        'imageUrl': imageUrl,
        'keywordList': keywordList,
        'scheduleIdList': scheduleIdList, // 생성된 scheduleId 리스트
        'createdAt': Timestamp.now(),
        'reportCount': 0,
        'isHidden': false,
        'viewCount': 0,
      };

      await packageRef.set(packageData);
    } catch (e) {
      throw Exception('패키지 등록 실패: $e');
    }
  }
}
