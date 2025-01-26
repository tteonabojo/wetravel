// login_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wetravel/domain/usecase/sign_in_usecase.dart';
import 'package:wetravel/presentation/pages/login/login_view_model.dart';

// SignInUseCase Provider
final signInUseCaseProvider = Provider<SignInUseCase>((ref) {
  return SignInUseCase(FirebaseAuth.instance, GoogleSignIn());
});

// LoginViewModel Provider
final loginViewModelProvider = Provider<LoginViewModel>((ref) {
  final signInUseCase = ref.watch(signInUseCaseProvider);
  return LoginViewModel(signInUseCase);
});
