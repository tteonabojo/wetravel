import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/domain/entity/user.dart';
import 'package:wetravel/presentation/provider/user_provider.dart';

class LoginPageViewModel extends Notifier<User?> {
  @override
  User? build() {
    return null;
  }

  /// 소셜 로그인
  Future<void> signInWithProvider({required provider}) async {
    try {
      final user = await ref
          .read(signInWithProviderUsecaseProvider)
          .execute(provider: provider);
      state = user;
    } catch (e) {
      throw Exception(e);
    }
  }

  /// 로그아웃
  Future<bool> signOut() async {
    try {
      return true;
    } catch (e) {
      log('LoginPageViewModel::signOut $e');
      return false;
    }
  }
}

final loginPageViewModel = NotifierProvider<LoginPageViewModel, User?>(() {
  return LoginPageViewModel();
});
