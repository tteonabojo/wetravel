import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/data/data_source/data_source_implement/user_data_source_impl.dart';
import 'package:wetravel/data/data_source/user_data_source.dart';
import 'package:wetravel/data/repository/user_repository_impl.dart';
import 'package:wetravel/domain/repository/user_repository.dart';
import 'package:wetravel/domain/usecase/sign_in_with_apple_usecase.dart';
import 'package:wetravel/domain/usecase/sign_in_with_google_usecase.dart';
import 'package:wetravel/presentation/pages/login/login_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// FirebaseAuth provider
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

// GoogleSignIn provider
final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  return GoogleSignIn();
});

// Firestore provider
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// UserDataSource provider
final userDataSourceProvider = Provider<UserDataSource>((ref) {
  final firestore = ref.read(firestoreProvider);
  return UserDataSourceImpl(firestore);
});

// UserRepository provider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final userDataSource = ref.read(userDataSourceProvider);
  final firebaseAuth = ref.read(firebaseAuthProvider);
  final googleSignIn = ref.read(googleSignInProvider);
  final firestore = ref.read(firestoreProvider);
  return UserRepositoryImpl(
      userDataSource, firebaseAuth, googleSignIn, firestore);
});

// Google 로그인 유즈케이스 프로바이더
final signInWithGoogleUseCaseProvider =
    Provider<SignInWithGoogleUseCase>((ref) {
  final firebaseAuth = ref.read(firebaseAuthProvider);
  final googleSignIn = ref.read(googleSignInProvider);
  final userRepository = ref.read(userRepositoryProvider);
  return SignInWithGoogleUseCase(firebaseAuth, googleSignIn, userRepository);
});

// Apple 로그인 유즈케이스 프로바이더
final signInWithAppleUseCaseProvider = Provider<SignInWithAppleUseCase>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  final firebaseAuth = ref.read(firebaseAuthProvider);
  return SignInWithAppleUseCase(userRepository, firebaseAuth);
});

// 로그인 뷰모델 프로바이더
final loginViewModelProvider = ChangeNotifierProvider<LoginViewModel>((ref) {
  final signInWithGoogleUseCase = ref.read(signInWithGoogleUseCaseProvider);
  final signInWithAppleUseCase = ref.read(signInWithAppleUseCaseProvider);
  return LoginViewModel(signInWithGoogleUseCase, signInWithAppleUseCase);
});
