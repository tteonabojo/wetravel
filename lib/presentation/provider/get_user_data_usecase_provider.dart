import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/domain/repository/user_repository.dart';
import 'package:wetravel/domain/usecase/get_user_data_usecase.dart';
import 'package:wetravel/presentation/provider/user_provider.dart';

final getUserDataUseCaseProvider = Provider<GetUserDataUseCase>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return GetUserDataUseCase(repository);
});