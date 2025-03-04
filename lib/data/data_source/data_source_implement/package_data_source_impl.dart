import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wetravel/core/constants/firestore_constants.dart';
import 'package:wetravel/data/data_source/package_data_source.dart';
import 'package:wetravel/data/dto/package_dto.dart';

class PackageDataSourceImpl extends FirestoreConstants
    implements PackageDataSource {
  final FirebaseFirestore _firestore;
  PackageDataSourceImpl(FirebaseFirestore firestore) : _firestore = firestore {
    _firestore.settings = Settings(
      persistenceEnabled: false, // 캐싱 활성화
      // cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }

  @override
  Future<List<PackageDto>> fetchPackages() async {
    final collectionRef = _firestore.collection(packagesCollection);
    final snapshot = await collectionRef.get();
    final documentSnapshot = snapshot.docs;
    return documentSnapshot.map((e) => PackageDto.fromJson(e.data())).toList();
  }

  @override
  Future<void> addPackage(Map<String, dynamic> packageData) async {
    await _firestore.collection(packagesCollection).add(packageData);
  }

  @override
  Future<List<PackageDto>> fetchPackagesByUserId(String userId) async {
    final snapshot = await _firestore
        .collection(packagesCollection)
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs.map((doc) {
      return PackageDto.fromJson(doc.data());
    }).toList();
  }

  @override
  Future<PackageDto> getPackageById(String packageId) async {
    final packageSnapshot =
        await _firestore.collection(packagesCollection).doc(packageId).get();
    if (packageSnapshot.exists) {
      final data = packageSnapshot.data()!;
      return PackageDto.fromMap(data);
    } else {
      throw Exception('Package not found');
    }
  }

  @override
  Future<Map<int, List<Map<String, String>>>> fetchSchedulesByIds(
      List<String> scheduleIds) async {
    Map<int, List<Map<String, String>>> schedules = {};

    for (String scheduleId in scheduleIds) {
      final scheduleSnapshot = await _firestore
          .collection(schedulesCollection)
          .doc(scheduleId)
          .get();
      if (scheduleSnapshot.exists) {
        final data = scheduleSnapshot.data()!;
        final day = data['day'] as int; // day를 int로 처리
        final scheduleDetails = data['scheduleDetails'];

        // scheduleDetails가 null이 아니면 추가
        if (scheduleDetails != null) {
          if (schedules.containsKey(day)) {
            schedules[day]!.add(scheduleDetails);
          } else {
            schedules[day] = [scheduleDetails];
          }
        }
      }
    }
    return schedules;
  }

  Future<List<PackageDto>> fetchRecentPackages() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) throw ('로그인이 필요합니다');

      final userSnapshot = await _firestore
          .collection(usersCollection)
          .doc(currentUser.uid)
          .get();

      List<String> recentPackageIds = [];
      if (userSnapshot.exists) {
        // 최근 패키지 ID 리스트가 정수로 저장된 경우 이를 문자열로 변환
        recentPackageIds =
            (userSnapshot.data()?['recentPackages'] as List<dynamic>)
                .map((e) => e.toString()) // 여기서 int를 String으로 변환
                .toList();
      } else {
        return [];
      }

      if (recentPackageIds.isNotEmpty) {
        final packageSnapshot = await _firestore
            .collection(packagesCollection)
            .where(FieldPath.documentId, whereIn: recentPackageIds)
            .get();

        final List userIds = packageSnapshot.docs
            .map((package) => package.data()['userId'])
            .toList();

        final userSnapshot = await _firestore
            .collection(usersCollection)
            .where(FieldPath.documentId, whereIn: userIds)
            .get();

        final Map<String, Map<String, dynamic>> userMap = {};
        for (var userDoc in userSnapshot.docs) {
          userMap[userDoc.id] = userDoc.data() as Map<String, dynamic>;
        }

        return packageSnapshot.docs.map((doc) {
          final packageData = doc.data();
          final userId = packageData['userId'] as String;
          final userData = userMap[userId];

          return PackageDto.fromJson({
            ...packageData,
            'userName': userData?['name'],
            'userImageUrl': userData?['imageUrl'],
          });
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<PackageDto>> fetchPopularPackages() async {
    try {
      final packageSnapshot = await _firestore
          .collection(packagesCollection)
          .orderBy('viewCount', descending: true)
          .limit(10)
          .get();

      final List userIds = packageSnapshot.docs
          .map((package) => package.data()['userId'])
          .toList();

      final userSnapshot = await _firestore
          .collection(usersCollection)
          .where(FieldPath.documentId, whereIn: userIds)
          .get();

      final Map<String, Map<String, dynamic>> userMap = {};
      for (var userDoc in userSnapshot.docs) {
        userMap[userDoc.id] = userDoc.data();
      }

      return packageSnapshot.docs.map((doc) {
        final packageData = doc.data();
        final userId = packageData['userId'];
        final userData = userMap[userId];
        return PackageDto.fromJson({
          ...packageData,
          'userName': userData?['name'],
          'userImageUrl': userData?['imageUrl'],
        });
      }).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Stream<List<PackageDto>> watchRecentPackages() async* {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      yield [];
      return;
    }

    yield* _firestore
        .collection(usersCollection)
        .doc(user.uid)
        .snapshots()
        .asyncMap((userSnapshot) async {
      try {
        if (!userSnapshot.exists) return [];

        List recentPackageIds =
            userSnapshot.data()?['recentPackages']?.toList() ?? [];
        if (recentPackageIds.isEmpty) return [];
        final packageSnapshot = await _firestore
            .collection(packagesCollection)
            .where(FieldPath.documentId, whereIn: recentPackageIds)
            .get();

        final sortedPackages = List.generate(
            packageSnapshot.docs.length,
            (index) => packageSnapshot.docs
                .where((e) => e.id == recentPackageIds[index])
                .first);

        final List userIds = sortedPackages
            .map((package) => package.data()['userId'] as String)
            .toList();

        if (userIds.isEmpty) return [];

        final userSnapshot2 = await _firestore
            .collection(usersCollection)
            .where(FieldPath.documentId, whereIn: userIds)
            .get();

        final Map<String, Map<String, dynamic>> userMap = {
          for (var userDoc in userSnapshot2.docs) userDoc.id: userDoc.data()
        };

        return sortedPackages.map((doc) {
          final packageData = doc.data();
          final userId = packageData['userId'] as String;
          final userData = userMap[userId];

          return PackageDto.fromJson({
            ...packageData,
            'userName': userData?['name'],
            'userImageUrl': userData?['imageUrl'],
          });
        }).toList();
      } catch (e) {
        print('Error fetching recent packages: $e');
        return [];
      }
    });
  }
}
