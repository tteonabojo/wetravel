import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wetravel/domain/entity/user.dart';
import 'package:wetravel/domain/usecase/fetch_user_usecase.dart';
import 'package:wetravel/presentation/pages/test/user_info/user_info_view_model.dart';
import 'package:wetravel/presentation/provider/user_provider.dart';

class MockFetchUserUsecase extends Mock implements FetchUserUsecase {}

void main() {
  late final ProviderContainer providerContainer;
  setUp(
    () async {
      final fetchUserUsecaseProviderOverride =
          fetchUserUsecaseProvider.overrideWith(
        (ref) => MockFetchUserUsecase(),
      );
      providerContainer =
          ProviderContainer(overrides: [fetchUserUsecaseProviderOverride]);
      addTearDown(providerContainer.dispose);
    },
  );

  test('UserInfoViewModel test : state update after fetchUser', () async {
    final fetchUserUsecase = providerContainer.read(fetchUserUsecaseProvider);
    when(() => fetchUserUsecase.execute())
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

    final stateBefore = providerContainer.read(userInfoViewModel);
    expect(stateBefore, isNull);
    await providerContainer.read(userInfoViewModel.notifier).fetchUser();

    final stateAfter = providerContainer.read(userInfoViewModel);
    expect(stateAfter, isNotNull);
    expect(stateAfter!.isGuide, false);
    expect(stateAfter.email, 'email');
  });
}
