import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/data/data_source/data_source_implement/package_data_source_impl.dart';
import 'package:wetravel/data/data_source/package_data_source.dart';
import 'package:wetravel/data/repository/package_repository_impl.dart';
import 'package:wetravel/domain/repository/package_repository.dart';
import 'package:wetravel/domain/usecase/fetch_packages_usecase.dart';

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
