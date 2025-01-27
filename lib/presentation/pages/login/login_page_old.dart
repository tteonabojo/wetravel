import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/auth_providers.dart';
import 'package:wetravel/presentation/pages/login/login_page_view_model.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  String? _appleUserName;
  String? _googleUserName;

  void changeUserName(String? name, {required bool isApple}) {
    setState(() {
      if (isApple) {
        _appleUserName = name;
      } else {
        _googleUserName = name;
      }
    });
  }

  void signInWithProvider({required provider}) async {
    await ref
        .read(loginPageViewModel.notifier)
        .signInWithProvider(provider: provider);
    final user = ref.read(loginPageViewModel);
    bool isApple = false;
    if (user?.loginType == AuthProviders.apple) isApple = true;
    print(user?.loginType);
    print(user?.name);
    print(user?.email);
    changeUserName(user?.name, isApple: isApple);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                signInWithProvider(provider: AuthProviders.apple);
              },
              child: Text("Sign in with Apple"),
            ),
          ),
          Text(
            _appleUserName != null ? "$_appleUserName" : "apple 유저 정보:",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                signInWithProvider(provider: AuthProviders.google);
              },
              child: Text("Sign in with google"),
            ),
          ),
          Text(
            _googleUserName != null ? "$_googleUserName" : "google 유저 정보:",
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
