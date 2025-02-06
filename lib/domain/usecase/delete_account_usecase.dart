import 'package:firebase_auth/firebase_auth.dart';

class DeleteAccountUsecase {
  final FirebaseAuth _auth;

  DeleteAccountUsecase(this._auth);

  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.delete(); // Firebase 계정 삭제
    }
  }
}