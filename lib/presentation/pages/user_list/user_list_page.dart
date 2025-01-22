import 'package:flutter/material.dart';

class UserListPage extends StatelessWidget {
  const UserListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('사용자 목록'),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
            height: 200,
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                AspectRatio(
                  aspectRatio: 2 / 3,
                  child: Image.network(
                    'https://picsum.photos/200/300',
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('이름'),
                    Text('이메일'),
                    Text('자기소개'),
                  ],
                ))
              ],
            ),
          );
        },
      ),
    );
  }
}
