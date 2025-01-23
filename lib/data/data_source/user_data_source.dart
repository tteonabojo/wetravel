import 'package:wetravel/data/dto/user_dto.dart';

abstract interface class UserDataSource {
  Future<List<UserDto>> fetchUsers();
}
