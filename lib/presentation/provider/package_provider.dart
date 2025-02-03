import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/di/injection_container.dart';
import 'package:wetravel/data/data_source/data_source_implement/package_data_source_impl.dart';
import 'package:wetravel/data/data_source/package_data_source.dart';
import 'package:wetravel/data/repository/package_repository_impl.dart';
import 'package:wetravel/domain/repository/package_repository.dart';
import 'package:wetravel/domain/usecase/add_package_usecase.dart';
import 'package:wetravel/domain/usecase/fetch_packages_usecase.dart';
import 'package:wetravel/domain/usecase/fetch_recent_packages_usecase.dart';
import 'package:wetravel/domain/usecase/fetch_user_packages_usecase.dart';

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

final packageDataSourceProvider =
    Provider((ref) => PackageDataSourceImpl(FirebaseFirestore.instance));
final packageRepositoryProvider = Provider(
    (ref) => PackageRepositoryImpl(ref.read(packageDataSourceProvider)));
final fetchUserPackagesUsecaseProvider = Provider(
    (ref) => FetchUserPackagesUseCase(ref.read(packageRepositoryProvider)));

/// 최근에 본 패키지 목록
final fetchRecentPackagesProvider = Provider(
    (ref) => FetchRecentPackagesUsecase(ref.read(packageRepositoryProvider)));
