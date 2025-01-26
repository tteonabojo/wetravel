import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/auth_providers.dart';
import 'package:wetravel/presentation/pages/login/login_page_view_model.dart';
import 'package:wetravel/presentation/pages/stack/stack_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  void signInWithProvider({required provider}) async {
    await ref
        .read(loginPageViewModel.notifier)
        .signInWithProvider(provider: provider);
    final user = ref.read(loginPageViewModel);
    if (user?.email != null) {
      print(user?.email);
      // TODO: 메인 페이지로 이동
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return StackPage();
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: 200,
                width: 200,
                color: Colors.grey,
                child: Center(
                  child: Text('Logo'),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  signInWithProvider(provider: AuthProviders.apple);
                },
                child: Row(
                  children: [
                    Icon(Icons.local_airport),
                    Text('apple'),
                  ],
                )),
            ElevatedButton(
                onPressed: () {
                  signInWithProvider(provider: AuthProviders.google);
                },
                child: Row(
                  children: [
                    Icon(Icons.local_airport),
                    Text('google'),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
