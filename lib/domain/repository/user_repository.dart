import 'package:wetravel/domain/entity/user.dart';

abstract interface class UserRepository {
  Future<List<User>> fetchUsers();
}
