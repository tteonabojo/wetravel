import 'package:wetravel/domain/entity/user.dart';
import 'package:wetravel/domain/repository/user_repository.dart';

class FetchUsersByIdsUsecase {
  FetchUsersByIdsUsecase(this._userRepository);
  final UserRepository _userRepository;

  Future<List<User>> execute(List<String> ids) async {
    return await _userRepository.fetchUsersByIds(ids);
  }
}
