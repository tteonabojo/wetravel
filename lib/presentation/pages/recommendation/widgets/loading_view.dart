import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_typography.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/animations/loading_animation.json',
            width: 150,
            height: 150,
            fit: BoxFit.contain,
            repeat: true,
          ),
          const SizedBox(height: 24),
          Text(
            'AI가 여행지를 추천하고 있어요',
            style: AppTypography.body1.copyWith(
              color: AppColors.grayScale_550,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
