import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/data/data_source/data_source_implement/user_data_source_impl.dart';
import 'package:wetravel/data/data_source/user_data_source.dart';
import 'package:wetravel/data/repository/user_repository_impl.dart';
import 'package:wetravel/domain/repository/user_repository.dart';
import 'package:wetravel/domain/usecase/fetch_user_usecase.dart';
import 'package:wetravel/domain/usecase/sign_in_with_provider_usecase.dart';

final _userDataSourceProvider = Provider<UserDataSource>((ref) {
  return UserDataSourceImpl(FirebaseFirestore.instance);
});

final _userRepositoryProvider = Provider<UserRepository>(
  (ref) {
    final dataSource = ref.watch(_userDataSourceProvider);
    return UserRepositoryImpl(dataSource);
  },
);

final fetchUserUsecaseProvider = Provider(
  (ref) {
    final userRepo = ref.watch(_userRepositoryProvider);
    return FetchUserUsecase(userRepo);
  },
);

final signInWithProviderUsecaseProvider = Provider((ref) {
  final userRepo = ref.read(_userRepositoryProvider);
  return SignInWithProviderUsecase(userRepo);
});
