import 'package:flutter/material.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_typography.dart';

/// AI 추천 페이지의 앱바
class RecommendationAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const RecommendationAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: Text(
        'AI 맞춤 여행지 추천',
        style: AppTypography.headline4.copyWith(
          color: AppColors.grayScale_950,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            '/',
            (route) => false,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
