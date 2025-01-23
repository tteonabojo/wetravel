import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wetravel/data/data_source/user_data_source.dart';
import 'package:wetravel/data/dto/user_dto.dart';
import 'package:wetravel/data/repository/user_repository_impl.dart';

class MockUserDataSource extends Mock implements UserDataSource {}

void main() {
  late final MockUserDataSource mockUserDataSource;
  late final UserRepositoryImpl userRepositoryImpl;
  setUp(
    () async {
      mockUserDataSource = MockUserDataSource();
      userRepositoryImpl = UserRepositoryImpl(mockUserDataSource);
    },
  );
  test(
    "UserRepositoryImpl test : fetchUsers",
    () async {
      when(() => mockUserDataSource.fetchUsers()).thenAnswer((_) async => [
            UserDto(
              id: 'id',
              email: 'email',
              password: 'password',
              name: 'name',
              imageUrl: 'imageUrl',
              introduction: 'introduction',
              loginType: 'loginType',
              isGuide: true,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              deletedAt: DateTime.now(),
              scrapList: [],
            )
          ]);
      final result = await userRepositoryImpl.fetchUsers();
      expect(result.length, 1);
      expect(result[0].email, 'email');
    },
  );
}
