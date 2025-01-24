// ViewModel에서 직접 객체 생성하지 않을 수 있게
// UseCase 공급해주는 Provider 생성
// ViewModel 내에서는 Provider에 의해서 UseCase 공급받을것.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/data/data_source/user_data_source_impl.dart';
import 'package:wetravel/data/data_source/user_data_source.dart';
import 'package:wetravel/data/repository/user_repository_impl.dart';
import 'package:wetravel/domain/repository/user_repository.dart';
import 'package:wetravel/domain/usecase/fetch_users_usecase.dart';
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

final fetchUsersUsecaseProvider = Provider(
  (ref) {
    final userRepo = ref.watch(_userRepositoryProvider);
    return FetchUsersUsecase(userRepo);
  },
);

final signInWithProviderUsecaseProvider = Provider((ref) {
  final userRepo = ref.read(_userRepositoryProvider);
  return SignInWithProviderUsecase(userRepo);
});
