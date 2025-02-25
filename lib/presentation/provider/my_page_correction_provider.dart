import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/data/repository/firebase_storage_repository_impl.dart';
import 'package:wetravel/domain/repository/firebase_storage_repository.dart';
import 'package:wetravel/domain/usecase/delete_account_usecase.dart';
import 'package:wetravel/domain/usecase/update_user_profile_usecase.dart';
import 'package:wetravel/domain/usecase/upload_profile_image_usecase.dart';
import 'package:wetravel/presentation/pages/my_page_correction/mypage_correction_view_model.dart';
import 'package:wetravel/presentation/provider/user_provider.dart'; // user_provider.dart import

final updateUserProfileUseCaseProvider = Provider((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return UpdateUserProfileUseCase(userRepository);
});

final uploadProfileImageUseCaseProvider = Provider((ref) {
  final firebaseStorageRepository = ref.watch(firebaseStorageRepositoryProvider);
  return UploadProfileImageUseCase(firebaseStorageRepository);
});

final firebaseStorageRepositoryProvider = Provider((ref) {
  return FirebaseStorageRepositoryImpl();
});

final deleteAccountUseCaseProvider = Provider((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return DeleteAccountUseCase(userRepository);
});

final myPageCorrectionViewModelProvider = ChangeNotifierProvider<MyPageCorrectionViewModel>((ref) {
  final updateUserProfileUseCase = ref.watch(updateUserProfileUseCaseProvider);
  final uploadProfileImageUseCase = ref.watch(uploadProfileImageUseCaseProvider);
  final deleteAccountUseCase = ref.watch(deleteAccountUseCaseProvider);

  return MyPageCorrectionViewModel(
    updateUserProfileUseCase: updateUserProfileUseCase,
    uploadProfileImageUseCase: uploadProfileImageUseCase,
    deleteAccountUseCase: deleteAccountUseCase,
  );
});