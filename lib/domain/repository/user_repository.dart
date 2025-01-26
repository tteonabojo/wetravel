import 'package:wetravel/domain/entity/user.dart';

abstract interface class UserRepository {
  Future<User?> fetchUser();

  Future<User?> signInWithGoogle();

  Future<User?> signInWithApple();

  Future<User?> getUserById(String userId);

  Future<void> saveUser(User user);
}
