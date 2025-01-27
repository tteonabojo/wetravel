// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get_it/get_it.dart';
// import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:wetravel/data/data_source/data_source_implement/user_data_source_impl.dart';
// import 'package:wetravel/data/data_source/user_data_source.dart';
// import 'package:wetravel/data/repository/user_repository_impl.dart';
// import 'package:wetravel/domain/repository/user_repository.dart';
// import 'package:wetravel/domain/usecase/sign_in_with_apple_usecase.dart';
// import 'package:wetravel/domain/usecase/sign_in_with_google_usecase.dart';
// import 'package:wetravel/presentation/pages/login/login_view_model.dart';

// final sl = GetIt.instance;

// void setupDependencies() {
//   // FirebaseAuth provider
//   sl.registerLazySingleton(() => FirebaseAuth.FirebaseAuth.instance);

//   // GoogleSignIn provider
//   sl.registerLazySingleton(() => GoogleSignIn());

//   // UserDataSource provider
//   sl.registerLazySingleton<UserDataSource>(() =>
//       UserDataSourceImpl(sl<FirebaseAuth.FirebaseAuth>() as FirebaseFirestore));

//   // UserRepository provider
//   sl.registerLazySingleton<UserRepository>(
//     () => UserRepositoryImpl(
//         sl<UserDataSource>(),
//         sl<FirebaseAuth.FirebaseAuth>(),
//         sl<GoogleSignIn>(),
//         sl<FirebaseFirestore>()),
//   );

//   // UseCases
//   sl.registerLazySingleton(() => SignInWithGoogleUseCase(
//       sl<FirebaseAuth.FirebaseAuth>(),
//       sl<GoogleSignIn>(),
//       sl<UserRepository>()));
//   sl.registerLazySingleton(() => SignInWithAppleUseCase(
//       sl<UserRepository>(), sl<FirebaseAuth.FirebaseAuth>()));

//   // ViewModel
//   sl.registerFactory(() => LoginViewModel(
//         sl<SignInWithGoogleUseCase>(),
//         sl<SignInWithAppleUseCase>(),
//       ));
// }
