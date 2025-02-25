import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/presentation/provider/saved_plans_provider.dart';

final savedPlansCountProvider = FutureProvider.autoDispose<int>((ref) async {
  final useCase = ref.watch(getSavedPlansCountUseCaseProvider);
  return await useCase.execute();
});

final savedGuidePlansCountProvider =
    FutureProvider.autoDispose<int>((ref) async {
  final useCase = ref.watch(getSavedPlansCountUseCaseProvider);
  return await useCase.execute();
});
