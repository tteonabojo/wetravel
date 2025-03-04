import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wetravel/core/constants/firestore_constants.dart';
import 'package:wetravel/data/data_source/package_data_source.dart';
import 'package:wetravel/domain/entity/package.dart';
import 'package:wetravel/domain/repository/package_repository.dart';

class PackageRepositoryImpl extends FirestoreConstants
    implements PackageRepository {
  PackageRepositoryImpl(this._packageDataSource);
  final PackageDataSource _packageDataSource;

  @override
  Future<List<Package>> fetchPackages() async {
    final result = await _packageDataSource.fetchPackages();
    return result
        .map((e) => Package(
              id: e.id,
              userId: e.userId,
              title: e.title,
              location: e.location,
              description: e.description,
              duration: e.duration,
              imageUrl: e.imageUrl,
              keywordList: e.keywordList,
              scheduleIdList: e.scheduleIdList,
              createdAt: e.createdAt,
              updatedAt: e.updatedAt,
              deletedAt: e.deletedAt,
              reportCount: e.reportCount,
              isHidden: e.isHidden,
              userImageUrl: e.userImageUrl!,
              userName: e.userName!,
            ))
        .toList();
  }

  @override
  Stream<List<Package>> watchPackages() {
    return FirebaseFirestore.instance
        .collection(packagesCollection)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Package.fromJson(doc.data())).toList();
    });
  }

  @override
  Future<Package> fetchPackageData(String packageId) async {
    final packageDto = await _packageDataSource.getPackageById(packageId);
    return Package.fromDto(packageDto); // DTO를 Entity로 변환
  }

  @override
  Future<void> addPackage(Map<String, dynamic> packageData) {
    return _packageDataSource.addPackage(packageData);
  }

  @override
  Future<List<Package>> fetchPackagesByUserId(String userId) async {
    final result = await _packageDataSource.fetchPackagesByUserId(userId);
    return result
        .map((e) => Package(
              id: e.id,
              userId: e.userId,
              title: e.title,
              location: e.location,
              description: e.description,
              duration: e.duration,
              imageUrl: e.imageUrl,
              keywordList: e.keywordList,
              scheduleIdList: e.scheduleIdList,
              createdAt: e.createdAt,
              updatedAt: e.updatedAt,
              deletedAt: e.deletedAt,
              reportCount: e.reportCount,
              isHidden: e.isHidden,
              userName: e.userName!,
              userImageUrl: e.userImageUrl!,
            ))
        .toList();
  }

  @override
  Future<Map<int, List<Map<String, String>>>> fetchSchedulesByIds(
      List<String> scheduleIds) {
    return _packageDataSource.fetchSchedulesByIds(scheduleIds);
  }

  Future<List<Package>> fetchRecentPackages() async {
    final result = await _packageDataSource.fetchRecentPackages();
    return result.map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<Package>> fetchPopularPackages() async {
    final result = await _packageDataSource.fetchPopularPackages();
    return result.map((e) => e.toEntity()).toList();
  }

  @override
  Stream<List<Package>> watchRecentPackages() async* {
    yield* _packageDataSource
        .watchRecentPackages()
        .map((packages) => packages.map((e) => e.toEntity()).toList());
  }

  @override
  Future<void> toggleIsHidden(String packageId, bool currentStatus) async {
    await FirebaseFirestore.instance
        .collection(packagesCollection)
        .doc(packageId)
        .update({'isHidden': !currentStatus});
  }

  @override
  Future<void> deletePackage(String packageId) async {
    final packageDoc = await FirebaseFirestore.instance
        .collection(packagesCollection)
        .doc(packageId)
        .get();

    if (packageDoc.exists) {
      final imageUrl = packageDoc.data()?['imageUrl'] as String?;
      if (imageUrl != null && imageUrl.isNotEmpty) {
        final storageRef = FirebaseStorage.instance.refFromURL(imageUrl);
        await storageRef.delete();
      }
    }

    final schedulesQuerySnapshot = await FirebaseFirestore.instance
        .collection(schedulesCollection)
        .where('packageId', isEqualTo: packageId)
        .get();

    await FirebaseFirestore.instance
        .collection(packagesCollection)
        .doc(packageId)
        .delete();

    for (var scheduleDoc in schedulesQuerySnapshot.docs) {
      await scheduleDoc.reference.delete();
    }
  }
}
