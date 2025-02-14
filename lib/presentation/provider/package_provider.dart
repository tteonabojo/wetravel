import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/firestore_constants.dart';
import 'package:wetravel/core/di/injection_container.dart';
import 'package:wetravel/data/data_source/data_source_implement/package_data_source_impl.dart';
import 'package:wetravel/data/data_source/package_data_source.dart';
import 'package:wetravel/data/repository/package_repository_impl.dart';
import 'package:wetravel/domain/repository/package_repository.dart';
import 'package:wetravel/domain/usecase/add_package_usecase.dart';
import 'package:wetravel/domain/usecase/fetch_package_schedule_usecase.dart';
import 'package:wetravel/domain/usecase/fetch_packages_usecase.dart';
import 'package:wetravel/domain/usecase/fetch_popular_packages_usecase.dart';
import 'package:wetravel/domain/usecase/fetch_recent_packages_usecase.dart';
import 'package:wetravel/domain/usecase/fetch_user_packages_usecase.dart';
import 'package:wetravel/domain/usecase/get_package_usecase.dart';
import 'package:wetravel/domain/usecase/watch_recent_packages_usecase.dart';

final _packageDataSourceProvider = Provider<PackageDataSource>((ref) {
  return PackageDataSourceImpl(FirebaseFirestore.instance);
});

final _packageRepositoryProvider = Provider<PackageRepository>(
  (ref) {
    final dataSource = ref.watch(_packageDataSourceProvider);
    return PackageRepositoryImpl(dataSource);
  },
);

final fetchPackagesUsecaseProvider = Provider(
  (ref) {
    final packageRepo = ref.watch(_packageRepositoryProvider);
    return FetchPackagesUsecase(packageRepo);
  },
);

final packageProvider = Provider((ref) => PackageProvider(sl()));

class PackageProvider {
  final AddPackageUseCase addPackageUseCase;

  PackageProvider(this.addPackageUseCase);

  Future<void> addPackage(Map<String, dynamic> packageData) async {
    try {
      await addPackageUseCase.execute(packageData);
    } catch (e) {
      throw Exception('패키지 추가 실패: $e');
    }
  }
}

final getPackageUseCaseProvider = Provider((ref) {
  final packageRepository = ref.read(packageRepositoryProvider);
  return GetPackageUseCase(packageRepository);
});

final packageDataSourceProvider =
    Provider((ref) => PackageDataSourceImpl(FirebaseFirestore.instance));
final packageRepositoryProvider = Provider(
    (ref) => PackageRepositoryImpl(ref.read(packageDataSourceProvider)));
final fetchUserPackagesUsecaseProvider = Provider(
    (ref) => FetchUserPackagesUseCase(ref.read(packageRepositoryProvider)));

final fetchPackageSchedulesUsecaseProvider = Provider((ref) {
  final packageRepository = ref.read(packageRepositoryProvider);
  return FetchPackageSchedulesUsecase(packageRepository);
});

/// 최근에 본 패키지 목록
final fetchRecentPackagesProvider = Provider(
    (ref) => FetchRecentPackagesUsecase(ref.read(packageRepositoryProvider)));

/// 인기 있는 패키지 목록
final fetchPopularPackagesProvider = Provider(
    (ref) => FetchPopularPackagesUsecase(ref.read(packageRepositoryProvider)));

/// 최근에 본 패키지 목록
final watchRecentPackagesProvider = Provider(
    (ref) => WatchRecentPackagesUsecase(ref.watch(packageRepositoryProvider)));

/// 스크랩한 패키지 목록
final scrapPackagesProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  final firestoreConstants = FirestoreConstants();

  final userId = auth.currentUser?.uid;
  print('호출됨 : $userId');
  if (userId == null) {
    return Stream.value([]);
  }

  final userDocRef =
      firestore.collection(firestoreConstants.usersCollection).doc(userId);
  print('호출됨');

  return userDocRef.snapshots().asyncMap((userSnapshot) async {
    if (!userSnapshot.exists) {
      return [];
    }

    final scrapIdList =
        List<String>.from(userSnapshot.data()?['scrapIdList'] ?? []);
    print('scrapIdList : $scrapIdList');

    if (scrapIdList.isEmpty) {
      return [];
    }
    final List<Map<String, dynamic>> allPackages = [];

    for (var i = 0; i < scrapIdList.length; i += 10) {
      final batchIds = scrapIdList.sublist(
          i, i + 10 > scrapIdList.length ? scrapIdList.length : i + 10);

      final packageDocs = await firestore
          .collection(firestoreConstants.packagesCollection)
          .where(FieldPath.documentId, whereIn: batchIds)
          .get();

      allPackages.addAll(packageDocs.docs.map((doc) => {
            'id': doc.id,
            ...doc.data(),
          }));
    }

    return allPackages;
  });
});
