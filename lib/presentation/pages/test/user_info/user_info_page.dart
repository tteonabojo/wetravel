import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/presentation/pages/test/user_info/user_info_view_model.dart';

class UserInfoPage extends StatelessWidget {
  const UserInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('사용자 정보'),
        ),
        body: Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final user = ref.watch(userInfoViewModel);
          if (user == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Container(
            height: 200,
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                AspectRatio(
                  aspectRatio: 2 / 3,
                  child: Image.network(
                    user.imageUrl!,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.name!),
                    Text(user.email),
                    Text(user.introduction!),
                  ],
                ))
              ],
            ),
          );
        }));
  }
}
