import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wetravel/domain/entity/schedule.dart';
import 'package:wetravel/domain/usecase/fetch_schedules_usecase.dart';
import 'package:wetravel/presentation/pages/test/schedule_list/schedule_list_view_model.dart';
import 'package:wetravel/presentation/provider/schedule_provider.dart';

class MockFetchSchedulesUsecase extends Mock implements FetchSchedulesUsecase {}

void main() {
  late final ProviderContainer providerContainer;
  setUp(
    () async {
      final fetchSchedulesUsecaseProviderOverride =
          fetchSchedulesUsecaseProvider.overrideWith(
        (ref) => MockFetchSchedulesUsecase(),
      );
      providerContainer =
          ProviderContainer(overrides: [fetchSchedulesUsecaseProviderOverride]);
      addTearDown(providerContainer.dispose);
    },
  );

  test('ScheduleListViewModel test : state update after fetchSchedules',
      () async {
    final fetchSchedulesUsecase =
        providerContainer.read(fetchSchedulesUsecaseProvider);
    when(() => fetchSchedulesUsecase.execute())
        .thenAnswer((invocation) async => [
              Schedule(
                id: 'id',
                packageId: 'packageId',
                title: 'title',
                content: 'content',
                imageUrl: 'imageUrl',
                order: 1,
              )
            ]);

    final stateBefore = providerContainer.read(scheduleListViewModel);
    expect(stateBefore, isNull);
    await providerContainer
        .read(scheduleListViewModel.notifier)
        .fetchSchedules();

    final stateAfter = providerContainer.read(scheduleListViewModel);
    expect(stateAfter, isNotNull);
    expect(stateAfter!.length, 1);
    expect(stateAfter[0].title, 'title');
  });
}
