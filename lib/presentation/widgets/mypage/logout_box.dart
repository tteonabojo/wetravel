import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/app_shadow.dart';
import 'package:wetravel/presentation/provider/user_provider.dart';

class LogoutBox extends ConsumerWidget {
  const LogoutBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signOutUseCase = ref.read(signOutUseCaseProvider);

    return GestureDetector(
      onTap: () async {
        await signOutUseCase.execute();
        Navigator.pushReplacementNamed(context, '/login');
      },
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: AppShadow.generalShadow,
        ),
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '로그아웃',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}