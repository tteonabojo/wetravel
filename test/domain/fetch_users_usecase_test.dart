import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wetravel/domain/entity/user.dart';
import 'package:wetravel/domain/repository/user_repository.dart';
import 'package:wetravel/domain/usecase/fetch_users_usecase.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late final MockUserRepository mockUserRepository;
  late final FetchUsersUsecase fetchUsersUsecase;
  setUp(
    () async {
      mockUserRepository = MockUserRepository();
      fetchUsersUsecase = FetchUsersUsecase(mockUserRepository);
    },
  );

  test(
    'FetchUsersUsecase test : fetchUsers',
    () async {
      when(() => mockUserRepository.fetchUsers())
          .thenAnswer((invocation) async => [
                User(
                  id: 'id',
                  email: 'email',
                  password: 'password',
                  name: 'name',
                  imageUrl: 'imageUrl',
                  introduction: 'introduction',
                  loginType: 'loginType',
                  isGuide: true,
                  createdAt: Timestamp.now(),
                  updatedAt: Timestamp.now(),
                )
              ]);

      final result = await fetchUsersUsecase.execute();
      expect(result.length, 1);
      expect(result[0].loginType, 'loginType');
    },
  );
}
