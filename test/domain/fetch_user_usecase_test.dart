import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wetravel/domain/entity/user.dart';
import 'package:wetravel/domain/repository/user_repository.dart';
import 'package:wetravel/domain/usecase/fetch_user_usecase.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late final MockUserRepository mockUserRepository;
  late final FetchUserUsecase fetchUserUsecase;
  setUp(
    () async {
      mockUserRepository = MockUserRepository();
      fetchUserUsecase = FetchUserUsecase(mockUserRepository);
    },
  );

  test(
    'FetchUserUsecase test : fetchUser',
    () async {
      when(() => mockUserRepository.fetchUser())
          .thenAnswer((invocation) async => User(
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
              ));

      final result = await fetchUserUsecase.execute();
      expect(result!.isGuide, false);
      expect(result.loginType, 'loginType');
    },
  );
}
