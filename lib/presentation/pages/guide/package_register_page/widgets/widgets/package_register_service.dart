import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wetravel/core/constants/firestore_constants.dart';

class PackageRegisterService {
  final FirestoreConstants firestoreConstants = FirestoreConstants();

  Future<void> registerPackage({
    required String title,
    required String location,
    required String imageUrl,
    required List<String> keywordList,
    required List<Map<String, dynamic>> scheduleList,
    required bool isHidden,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('로그인한 사용자 정보를 찾을 수 없습니다.');
    }

    // 현재 사용자 정보를 Firestore에서 가져오기
    final userRef = FirebaseFirestore.instance
        .collection(firestoreConstants.usersCollection)
        .doc(currentUser.uid);
    final userSnapshot = await userRef.get();

    if (!userSnapshot.exists) {
      throw Exception('사용자 정보가 존재하지 않습니다.');
    }

    final userData = userSnapshot.data();
    final userName = userData?['name'] ?? 'Unknown User'; // 사용자의 이름
    final userImageUrl = userData?['imageUrl'] ?? ''; // 사용자의 이미지 URL

    // 패키지 ID 생성
    final packageRef = FirebaseFirestore.instance
        .collection(firestoreConstants.packagesCollection)
        .doc();
    final packageId = packageRef.id;

    // 스케줄 문서 리스트 저장
    List<String> scheduleIdList = [];
    try {
      // 일정들 (scheduleList)을 schedules 컬렉션에 각각 저장
      for (Map schedule in scheduleList) {
        // scheduleId를 packageId를 접두사로 붙여서 생성
        final scheduleRef = FirebaseFirestore.instance
            .collection(firestoreConstants.schedulesCollection)
            .doc(
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
        'userName': userName, // 로그인한 사용자의 이름 추가
        'userImageUrl': userImageUrl, // 로그인한 사용자의 이미지 URL 추가
        'title': title,
        'location': location,
        'imageUrl': imageUrl,
        'keywordList': keywordList,
        'scheduleIdList': scheduleIdList, // 생성된 scheduleId 리스트
        'createdAt': Timestamp.now(),
        'reportCount': 0,
        'isHidden': isHidden,
        'viewCount': 0,
      };

      await packageRef.set(packageData);
    } catch (e) {
      throw Exception('패키지 등록 실패: $e');
    }
  }

  Future<void> updatePackage({
    required String packageId,
    required String title,
    required String location,
    required String description,
    required String duration,
    required String imageUrl,
    required List<String> keywordList,
    required List<Map<String, dynamic>> scheduleList,
    required bool isHidden,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception('로그인한 사용자 정보를 찾을 수 없습니다.');
    }

    final packageRef = FirebaseFirestore.instance
        .collection(firestoreConstants.packagesCollection)
        .doc(packageId);

    try {
      final packageSnapshot = await packageRef.get();
      final packageData = packageSnapshot.data();

      if (packageData == null) {
        throw Exception('패키지 정보를 찾을 수 없습니다.');
      }

      final userName =
          packageData['userName'] ?? (await _getUserName(currentUser.uid));
      final userImageUrl = packageData['userImageUrl'] ??
          (await _getUserImageUrl(currentUser.uid));

      final oldImageUrl = packageData['imageUrl'] as String;

      // 기존 이미지와 새로운 이미지가 다를 경우 기존 이미지 삭제
      if (oldImageUrl.isNotEmpty && oldImageUrl != imageUrl) {
        await _deleteImageFromStorage(oldImageUrl);
      }

      final schedulesQuerySnapshot = await FirebaseFirestore.instance
          .collection(firestoreConstants.schedulesCollection)
          .where('packageId', isEqualTo: packageId)
          .get();

      for (var doc in schedulesQuerySnapshot.docs) {
        await doc.reference.delete();
      }

      List<String> updatedScheduleIdList = [];
      for (var schedule in scheduleList) {
        final scheduleRef = FirebaseFirestore.instance
            .collection(firestoreConstants.schedulesCollection)
            .doc();

        final scheduleData = {
          'id': scheduleRef.id,
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
        updatedScheduleIdList.add(scheduleRef.id);
      }

      await packageRef.update({
        'title': title,
        'location': location,
        'description': description,
        'duration': duration,
        'imageUrl': imageUrl,
        'keywordList': keywordList,
        'userName': userName,
        'userImageUrl': userImageUrl,
        'scheduleIdList': updatedScheduleIdList,
        'isHidden': isHidden,
      });
    } catch (e) {
      throw Exception('패키지 업데이트 실패: $e');
    }
  }

  Future<void> _deleteImageFromStorage(String imageUrl) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      print('이미지 삭제 실패: $e');
    }
  }

  // 사용자 이름 가져오기
  Future<String> _getUserName(String userId) async {
    final userRef = FirebaseFirestore.instance
        .collection(firestoreConstants.usersCollection)
        .doc(userId);
    final userSnapshot = await userRef.get();
    return userSnapshot.data()?['name'] ?? 'Unknown User';
  }

  // 사용자 이미지 URL 가져오기
  Future<String> _getUserImageUrl(String userId) async {
    final userRef = FirebaseFirestore.instance
        .collection(firestoreConstants.usersCollection)
        .doc(userId);
    final userSnapshot = await userRef.get();
    return userSnapshot.data()?['imageUrl'] ?? '';
  }
}
