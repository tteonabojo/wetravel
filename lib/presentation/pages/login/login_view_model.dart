import 'package:flutter/foundation.dart';
import 'package:wetravel/domain/usecase/sign_in_with_apple_usecase.dart';
import 'package:wetravel/domain/usecase/sign_in_with_google_usecase.dart';

class LoginViewModel extends ChangeNotifier {
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;
  final SignInWithAppleUseCase _signInWithAppleUseCase;

  LoginViewModel(
    this._signInWithGoogleUseCase,
    this._signInWithAppleUseCase,
  );

  String? _appleUserName;
  String? _googleUserName;
  bool _isLoggedIn = false;

  String? get appleUserName => _appleUserName;
  String? get googleUserName => _googleUserName;
  bool get isLoggedIn => _isLoggedIn;

  /// 구글/애플 로그인 처리
  Future<void> signInWithProvider({required String provider}) async {
    try {
      if (provider == 'Google') {
        final user = await _signInWithGoogleUseCase.execute();
        _googleUserName = user?.name;
      } else if (provider == 'Apple') {
        final user = await _signInWithAppleUseCase.execute();
        _appleUserName = user?.name;
      } else {
        throw Exception('Unsupported provider: $provider');
      }

      _isLoggedIn = true;
      notifyListeners();
    } catch (e) {
      print('Sign-In failed: $e');
      throw Exception('$provider Sign-In failed');
    }
  }
}
