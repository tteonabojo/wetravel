import 'package:flutter/foundation.dart';
import 'package:wetravel/domain/usecase/sign_in_usecase.dart';

class LoginViewModel extends ChangeNotifier {
  final SignInUseCase _signInUseCase;

  LoginViewModel(this._signInUseCase);

  String? _appleUserName;
  String? _googleUserName;
  bool _isLoggedIn = false;

  String? get appleUserName => _appleUserName;
  String? get googleUserName => _googleUserName;
  bool get isLoggedIn => _isLoggedIn;

  void changeUserName(String? name, {required bool isApple}) {
    if (isApple) {
      _appleUserName = name;
    } else {
      _googleUserName = name;
    }
    notifyListeners();
  }

  Future<void> signInWithProvider({required String provider}) async {
    try {
      if (provider == 'Google') {
        final userCredential = await _signInUseCase.signInWithGoogle();
        changeUserName(userCredential?.user?.displayName, isApple: false);
      } else if (provider == 'Apple') {
        final userCredential = await _signInUseCase.signInWithApple();
        changeUserName(userCredential?.user?.email, isApple: true);
      } else {
        throw Exception('Unsupported provider: $provider');
      }

      _isLoggedIn = true;
      notifyListeners();
    } catch (e) {
      throw Exception('$provider Sign-In failed: $e');
    }
  }
}
