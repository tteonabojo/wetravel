import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/domain/entity/user.dart';
import 'package:wetravel/presentation/provider/user_provider.dart';

class UserInfoViewModel extends Notifier<User?> {
  @override
  User? build() {
    fetchUser();
    return null;
  }

  Future<void> fetchUser() async {
    state = await ref.watch(fetchUserUsecaseProvider).execute();
  }
}

final userInfoViewModel =
    NotifierProvider<UserInfoViewModel, User?>(() => UserInfoViewModel());
