import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/domain/entity/user.dart';
import 'package:wetravel/presentation/provider/user_provider.dart';

class UserListViewModel extends Notifier<List<User>?> {
  @override
  List<User>? build() {
    fetchUsers();
    return null;
  }

  Future<void> fetchUsers() async {
    state = await ref.watch(fetchUsersUsecaseProvider).execute();
    print(state);
  }
}

final userListViewModel =
    NotifierProvider<UserListViewModel, List<User>?>(() => UserListViewModel());
