import 'package:flutter/material.dart';
import 'package:wetravel/constants/app_colors.dart';
import 'package:wetravel/constants/app_icons.dart';
import 'package:wetravel/constants/app_typography.dart';

enum SocialLoginType { apple, google }

class SocialLoginButton extends StatelessWidget {
  final SocialLoginType loginType;
  final VoidCallback onPressed;

  const SocialLoginButton(
      {super.key, required this.loginType, required this.onPressed});

  factory SocialLoginButton.apple({Key? key, required VoidCallback onPressed}) {
    return SocialLoginButton(
      key: key,
      loginType: SocialLoginType.apple,
      onPressed: onPressed,
    );
  }

  factory SocialLoginButton.google(
      {Key? key, required VoidCallback onPressed}) {
    return SocialLoginButton(
      key: key,
      loginType: SocialLoginType.google,
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (loginType) {
      case SocialLoginType.apple:
        return _buildAppleButton();
      case SocialLoginType.google:
        return _buildGoogleButton();
    }
  }

  Widget _buildAppleButton() {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 32,
            top: 0,
            bottom: 0,
            child: AppIcons.apple,
          ),
          const Center(
            child: Text(
              "Apple로 로그인",
              style: AppTypography.buttonLabelMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoogleButton() {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: const BorderSide(color: AppColors.grayScale_250),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 32,
            top: 0,
            bottom: 0,
            child: AppIcons.google,
          ),
          const Center(
            child: Text(
              "Google로 로그인",
              style: AppTypography.buttonLabelMedium,
            ),
          ),
        ],
      ),
    );
  }
}
