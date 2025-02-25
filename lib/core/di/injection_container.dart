import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wetravel/data/data_source/user_data_source.dart';
import 'package:wetravel/data/repository/user_repository_impl.dart';
import 'package:wetravel/domain/repository/firebase_storage_repository.dart';
import 'package:wetravel/domain/repository/user_repository.dart';
import 'package:wetravel/domain/usecase/update_user_profile_usecase.dart';
import 'package:wetravel/domain/usecase/upload_profile_image_usecase.dart';
import 'package:wetravel/domain/usecase/delete_account_usecase.dart';
import '../../data/data_source/package_data_source.dart';
import '../../data/data_source/data_source_implement/package_data_source_impl.dart';
import '../../data/repository/package_repository_impl.dart';
import '../../domain/repository/package_repository.dart';
import '../../domain/usecase/package/add_package_usecase.dart';

final sl = GetIt.instance;

void init() {
  // Firestore 인스턴스 등록
  sl.registerLazySingleton(() => FirebaseFirestore.instance);

  // Data Source
  sl.registerLazySingleton<PackageDataSource>(
      () => PackageDataSourceImpl(sl()));

  // Repository
  sl.registerLazySingleton<PackageRepository>(
      () => PackageRepositoryImpl(sl()));

  // Use Case
  sl.registerLazySingleton(() => AddPackageUseCase(sl()));

  // UpdateUserProfileUseCase
  sl.registerLazySingleton<UpdateUserProfileUseCase>(
      () => UpdateUserProfileUseCase(sl<UserRepository>()));

  // UploadProfileImageUseCase
  sl.registerLazySingleton<UploadProfileImageUseCase>(
      () => UploadProfileImageUseCase(sl<FirebaseStorageRepository>()));

  // DeleteAccountUseCase
  sl.registerLazySingleton<DeleteAccountUseCase>(
      () => DeleteAccountUseCase(sl<UserRepository>()));

  // UserDataSource, FirebaseFirestore, FirebaseAuth   
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(
    sl<UserDataSource>(), sl<FirebaseFirestore>(), sl<FirebaseAuth>()));
}
