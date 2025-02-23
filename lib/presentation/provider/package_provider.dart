import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/firestore_constants.dart';
import 'package:wetravel/core/di/injection_container.dart';
import 'package:wetravel/data/data_source/data_source_implement/package_data_source_impl.dart';
import 'package:wetravel/data/data_source/package_data_source.dart';
import 'package:wetravel/data/repository/package_repository_impl.dart';
import 'package:wetravel/domain/entity/package.dart';
import 'package:wetravel/domain/repository/package_repository.dart';
import 'package:wetravel/domain/usecase/package/add_package_usecase.dart';
import 'package:wetravel/domain/usecase/schedule/fetch_package_schedule_usecase.dart';
import 'package:wetravel/domain/usecase/package/fetch_packages_usecase.dart';
import 'package:wetravel/domain/usecase/package/fetch_popular_packages_usecase.dart';
import 'package:wetravel/domain/usecase/package/fetch_recent_packages_usecase.dart';
import 'package:wetravel/domain/usecase/package/fetch_user_packages_usecase.dart';
import 'package:wetravel/domain/usecase/package/get_package_usecase.dart';
import 'package:wetravel/domain/usecase/package/watch_recent_packages_usecase.dart';
import 'package:wetravel/presentation/provider/user_provider.dart';

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
  if (userId == null) {
    return Stream.value([]);
  }

  final userDocRef =
      firestore.collection(firestoreConstants.usersCollection).doc(userId);

  return userDocRef.snapshots().asyncMap((userSnapshot) async {
    if (!userSnapshot.exists) {
      return [];
    }

    final scrapIdList =
        List<String>.from(userSnapshot.data()?['scrapIdList'] ?? []);

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

final packagesProvider = StreamProvider<List<Package>>((ref) {
  final authState = ref.watch(authStateChangesProvider); // Firebase 인증 상태 감지
  final FirestoreConstants firestoreConstants = FirestoreConstants();

  return authState.when(
    data: (user) {
      if (user == null) {
        return Stream.value([]); // 유저가 없으면 빈 리스트 반환
      }
      final fetchPackagesUsecase = ref.watch(fetchPackagesUsecaseProvider);
      final firestore = FirebaseFirestore.instance;

      return fetchPackagesUsecase.watch().asyncMap((packages) async {
        return Future.wait(packages.map((package) async {
          if (package.userId.isEmpty) {
            return package.copyWith(userName: 'no name', userImageUrl: '');
          }

          final userDoc = await firestore
              .collection(firestoreConstants.usersCollection)
              .doc(package.userId)
              .get();

          if (!userDoc.exists) {
            return package.copyWith(userName: 'no name', userImageUrl: '');
          }

          final userData = userDoc.data();
          final guideName = userData?['name'] as String? ?? 'no name';
          final guideImageUrl = userData?['imageUrl'] as String? ?? '';

          return package.copyWith(
              userName: guideName, userImageUrl: guideImageUrl);
        }));
      });
    },
    loading: () => Stream.value([]), // 로딩 중일 때 빈 리스트 반환
    error: (_, __) => Stream.value([]), // 오류 발생 시 빈 리스트 반환
  );
});
