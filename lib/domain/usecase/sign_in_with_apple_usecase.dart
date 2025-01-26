import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:wetravel/domain/entity/user.dart';
import 'package:wetravel/domain/repository/user_repository.dart';

class SignInWithAppleUseCase {
  final UserRepository repository;

  SignInWithAppleUseCase(
      this.repository, FirebaseAuth.FirebaseAuth firebaseAuth);

  Future<User?> execute() async {
    return await repository.fetchUser();
  }

  Future<User?> call() async {
    return await repository.signInWithApple();
  }
}
