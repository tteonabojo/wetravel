import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wetravel/domain/usecase/user/delete_account_usecase.dart';

final deleteAccountUsecaseProvider = Provider<DeleteAccountUsecase>((ref) {
  return DeleteAccountUsecase(FirebaseAuth.instance);
});
