import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wetravel/domain/entity/banner.dart';
import 'package:wetravel/domain/usecase/fetch_banners_usecase.dart';
import 'package:wetravel/presentation/pages/test/banner_list/banner_list_view_model.dart';
import 'package:wetravel/presentation/provider/banner_provider.dart';

class MockFetchBannersUsecase extends Mock implements FetchBannersUsecase {}

void main() {
  late final ProviderContainer providerContainer;
  setUp(
    () async {
      final fetchBannersUsecaseProviderOverride =
          fetchBannersUsecaseProvider.overrideWith(
        (ref) => MockFetchBannersUsecase(),
      );
      providerContainer =
          ProviderContainer(overrides: [fetchBannersUsecaseProviderOverride]);
      addTearDown(providerContainer.dispose);
    },
  );

  test('BannerListViewModel test : state update after fetchBanners', () async {
    final fetchBannersUsecase =
        providerContainer.read(fetchBannersUsecaseProvider);
    when(() => fetchBannersUsecase.execute()).thenAnswer((invocation) async => [
          Banner(
            id: 'id',
            linkUrl: 'linkUrl',
            imageUrl: 'imageUrl',
            startDate: Timestamp.now(),
            endDate: Timestamp.now(),
            isHidden: false,
            company: 'company',
            description: 'description',
            order: 1,
          )
        ]);

    final stateBefore = providerContainer.read(bannerListViewModel);
    expect(stateBefore, isNull);
    await providerContainer.read(bannerListViewModel.notifier).fetchBanners();

    final stateAfter = providerContainer.read(bannerListViewModel);
    expect(stateAfter, isNotNull);
    expect(stateAfter!.length, 1);
    expect(stateAfter[0].company, 'company');
  });
}
