import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/presentation/pages/test/user_info/user_info_page.dart';
import 'package:wetravel/presentation/provider/login_provider.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // LoginViewModel 가져오기
    final viewModel = ref.watch(loginViewModelProvider);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                viewModel.signInWithProvider(provider: 'Apple');
              },
              child: const Text("Sign in with Apple"),
            ),
          ),
          Text(
            viewModel.appleUserName != null
                ? "${viewModel.appleUserName}"
                : "Apple 유저 정보:",
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                viewModel.signInWithProvider(provider: 'Google');
              },
              child: const Text("Sign in with Google"),
            ),
          ),
          Text(
            viewModel.googleUserName != null
                ? "${viewModel.googleUserName}"
                : "Google 유저 정보:",
            style: const TextStyle(fontSize: 16),
          ),
          if (viewModel.isLoggedIn)
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const UserInfoPage()),
                  (route) => false,
                );
              },
              child: const Text("UserInfoPage로 이동"),
            ),
        ],
      ),
    );
  }
}
