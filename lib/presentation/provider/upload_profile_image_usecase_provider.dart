import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/domain/repository/firebase_storage_repository.dart';
import 'package:wetravel/domain/usecase/upload_profile_image_usecase.dart';
import 'package:wetravel/presentation/provider/user_provider.dart';

final uploadProfileImageUseCaseProvider = Provider<UploadProfileImageUseCase>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return UploadProfileImageUseCase(repository as FirebaseStorageRepository);
});