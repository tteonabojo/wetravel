import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/domain/usecase/delete_account_usecase.dart';
import 'package:wetravel/presentation/provider/update_user_profile_usecase_provider.dart';
import 'package:wetravel/presentation/provider/user_provider.dart';

final deleteAccountUsecaseProvider = Provider<DeleteAccountUseCase>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return DeleteAccountUseCase(userRepository);
});
