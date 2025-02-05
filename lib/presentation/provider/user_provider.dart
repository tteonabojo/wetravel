import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/data/data_source/data_source_implement/user_data_source_impl.dart';
import 'package:wetravel/data/data_source/user_data_source.dart';
import 'package:wetravel/data/repository/user_repository_impl.dart';
import 'package:wetravel/domain/repository/user_repository.dart';
import 'package:wetravel/domain/usecase/fetch_user_usecase.dart';
import 'package:wetravel/domain/usecase/sign_in_with_provider_usecase.dart';
import 'package:wetravel/domain/usecase/sign_out_usecase.dart';

final _firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final _firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final _userDataSourceProvider = Provider<UserDataSource>((ref) {
  final firebaseFirestore = ref.watch(_firebaseFirestoreProvider);
  return UserDataSourceImpl(firebaseFirestore);
});

final userRepositoryProvider = Provider<UserRepository>(
  (ref) {
    final dataSource = ref.watch(_userDataSourceProvider);
    final firebaseFirestore =
        ref.watch(_firebaseFirestoreProvider); // firestore 의존성 추가
    final firebaseAuth =
        ref.watch(_firebaseAuthProvider); // firebaseAuth 의존성 추가
    return UserRepositoryImpl(dataSource, firebaseFirestore, firebaseAuth);
  },
);

final fetchUserUsecaseProvider = Provider(
  (ref) {
    final userRepo = ref.watch(userRepositoryProvider);
    return FetchUserUsecase(userRepo);
  },
);

/// 소셜 로그인
final signInWithProviderUsecaseProvider = Provider((ref) {
  final userRepo = ref.read(userRepositoryProvider);
  return SignInWithProviderUsecase(userRepo);
});

final isGuideProvider = FutureProvider<bool>((ref) async {
  final fetchUserUsecase = ref.watch(fetchUserUsecaseProvider);
  final user = await fetchUserUsecase.execute();
  return user.isGuide;
});

/// 로그아웃
final signOutUsecaseProvider =
    Provider((ref) => ref.read(userRepositoryProvider));

final userProvider = FutureProvider((ref) async {
  final fetchUserUsecase = ref.watch(fetchUserUsecaseProvider);
  return await fetchUserUsecase.execute();
});

final authStateProvider = StreamProvider.autoDispose<User?>((ref) {
  final firebaseAuth = ref.watch(_firebaseAuthProvider);
  return firebaseAuth.authStateChanges();
});
