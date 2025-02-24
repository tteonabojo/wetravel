import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/domain/usecase/update_user_profile_usecase.dart';
import 'package:wetravel/presentation/provider/user_provider.dart';

final updateUserProfileUseCaseProvider = Provider<UpdateUserProfileUseCase>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return UpdateUserProfileUseCase(repository);
});