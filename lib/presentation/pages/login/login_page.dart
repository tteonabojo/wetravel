import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wetravel/core/constants/app_icons.dart';
import 'package:wetravel/core/constants/auth_providers.dart';
import 'package:wetravel/presentation/pages/login/login_page_view_model.dart';
import 'package:wetravel/presentation/pages/stack/stack_page.dart';
import 'package:wetravel/presentation/widgets/buttons/social_login_button.dart';

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
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        child: Column(
          spacing: 16,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                height: 175,
                width: 200,
                child: Center(
                  child: SvgPicture.asset(AppIcons.logo, height: 125),
                ),
              ),
            ),
            SvgPicture.asset(AppIcons.logoLetter, height: 40),
            SizedBox(height: 10),
            SocialLoginButton.apple(
              onPressed: () {
                signInWithProvider(provider: AuthProviders.apple);
              },
            ),
            SocialLoginButton.google(
              onPressed: () {
                signInWithProvider(provider: AuthProviders.google);
              },
            ),
          ],
        ),
      ),
    );
  }
}
