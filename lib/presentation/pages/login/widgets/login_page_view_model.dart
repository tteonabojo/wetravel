import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/domain/entity/user.dart';

class LoginPageViewModel extends Notifier<User> {
  @override
  User build() {
    // TODO: implement build
    throw UnimplementedError();
  }

  // Future<User> signInWithProvider() async {
  //   try {
  //     //
  //   } catch (e) {
  //     throw Exception(e);
  //   }
  // }
}

final loginPageViewModel = NotifierProvider<LoginPageViewModel, User>(() {
  return LoginPageViewModel();
});
