import 'package:cloud_firestore/cloud_firestore.dart';
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
    "UserRepositoryImpl test : fetchUser",
    () async {
      when(() => mockUserDataSource.fetchUser())
          .thenAnswer((_) async => UserDto(
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
                deletedAt: Timestamp.now(),
                scrapList: [],
              ));
      final result = await userRepositoryImpl.fetchUser();
      expect(result?.name, 'name');
      expect(result!.email, 'email');
    },
  );
}
