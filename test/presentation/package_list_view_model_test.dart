import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wetravel/domain/entity/package.dart';
import 'package:wetravel/domain/usecase/fetch_packages_usecase.dart';
import 'package:wetravel/presentation/pages/test/package_list/package_list_view_model.dart';
import 'package:wetravel/presentation/provider/package_provider.dart';

class MockFetchPackagesUsecase extends Mock implements FetchPackagesUsecase {}

void main() {
  late final ProviderContainer providerContainer;
  setUp(
    () async {
      final fetchPackagesUsecaseProviderOverride =
          fetchPackagesUsecaseProvider.overrideWith(
        (ref) => MockFetchPackagesUsecase(),
      );
      providerContainer =
          ProviderContainer(overrides: [fetchPackagesUsecaseProviderOverride]);
      addTearDown(providerContainer.dispose);
    },
  );

  test('PackageListViewModel test : state update after fetchPackages',
      () async {
    final fetchPackagesUsecase =
        providerContainer.read(fetchPackagesUsecaseProvider);
    when(() => fetchPackagesUsecase.execute())
        .thenAnswer((invocation) async => [
              Package(
                id: 'id',
                userId: 'userId',
                title: 'title',
                location: 'location',
                description: 'description',
                duration: 'duration',
                imageUrl: 'imageUrl',
                keywordList: [],
                schedule: [],
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              )
            ]);

    final stateBefore = providerContainer.read(packageListViewModel);
    expect(stateBefore, isNull);
    await providerContainer.read(packageListViewModel.notifier).fetchPackages();

    final stateAfter = providerContainer.read(packageListViewModel);
    expect(stateAfter, isNotNull);
    expect(stateAfter!.length, 1);
    expect(stateAfter[0].title, 'title');
  });
}
