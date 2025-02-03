import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wetravel/data/data_source/package_data_source.dart';
import 'package:wetravel/data/dto/package_dto.dart';

class PackageDataSourceImpl implements PackageDataSource {
  final FirebaseFirestore _firestore;
  PackageDataSourceImpl(FirebaseFirestore firestore) : _firestore = firestore {
    _firestore.settings = Settings(
      persistenceEnabled: true, // 캐싱 활성화
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }

  @override
  Future<List<PackageDto>> fetchPackages() async {
    final collectionRef = _firestore.collection('packages');
    final snapshot = await collectionRef.get();
    final documentSnapshot = snapshot.docs;
    for (var docSnapshot in documentSnapshot) {
      print(docSnapshot.id);
      print(docSnapshot.data());
    }
    return documentSnapshot.map((e) => PackageDto.fromJson(e.data())).toList();
  }

  @override
  Future<void> addPackage(Map<String, dynamic> packageData) async {
    await _firestore.collection('packages').add(packageData);
  }

  @override
  Future<List<PackageDto>> fetchPackagesByUserId(String userId) async {
    final snapshot = await _firestore
        .collection('packages')
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs.map((doc) {
      return PackageDto.fromJson(doc.data());
    }).toList();
  }

  @override
  Future<List<PackageDto>> fetchRecentPackages() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) throw ('로그인이 필요합니다');

      final userSnapshot =
          await _firestore.collection('users').doc(currentUser.uid).get();

      List recentPackageIds = [];
      if (userSnapshot.exists) {
        recentPackageIds = userSnapshot.data()?['recentPackages'].toList();
      } else {
        return [];
      }

      if (recentPackageIds.isNotEmpty) {
        final packageSnapshot = await _firestore
            .collection('packages')
            .where(FieldPath.documentId, whereIn: recentPackageIds)
            .get();

        final List userIds = packageSnapshot.docs
            .map((package) => package.data()['userId'])
            .toList();

        final userSnapshot = await _firestore
            .collection('users')
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
}
