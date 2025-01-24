import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wetravel/domain/entity/user.dart';
import 'package:wetravel/domain/usecase/fetch_users_usecase.dart';
import 'package:wetravel/presentation/pages/test/user_list/user_list_view_model.dart';
import 'package:wetravel/presentation/provider/user_provider.dart';

class MockFetchUsersUsecase extends Mock implements FetchUsersUsecase {}

void main() {
  late final ProviderContainer providerContainer;
  setUp(
    () async {
      final fetchUsersUsecaseProviderOverride =
          fetchUsersUsecaseProvider.overrideWith(
        (ref) => MockFetchUsersUsecase(),
      );
      providerContainer =
          ProviderContainer(overrides: [fetchUsersUsecaseProviderOverride]);
      addTearDown(providerContainer.dispose);
    },
  );

  test('UserListViewModel test : state update after fetchUsers', () async {
    final fetchUsersUsecase = providerContainer.read(fetchUsersUsecaseProvider);
    when(() => fetchUsersUsecase.execute()).thenAnswer((invocation) async => [
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

    final stateBefore = providerContainer.read(userListViewModel);
    expect(stateBefore, isNull);
    await providerContainer.read(userListViewModel.notifier).fetchUsers();

    final stateAfter = providerContainer.read(userListViewModel);
    expect(stateAfter, isNotNull);
    expect(stateAfter!.length, 1);
    expect(stateAfter[0].email, 'email');
  });
}
