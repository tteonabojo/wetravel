import 'package:flutter/material.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_spacing.dart';
import 'package:wetravel/core/constants/app_typography.dart';

class GuideApplyPage extends StatelessWidget {
  const GuideApplyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: AppSpacing.large20,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '가이드에 도전해보세요!',
                textAlign: TextAlign.center,
                style: AppTypography.headline3.copyWith(
                  color: AppColors.grayScale_950,
                ),
              ),
              Padding(padding: AppSpacing.small4),
              Text(
                '내가 만든 일정 패키지로\n누군가의 소중한 추억을 만들어주세요',
                textAlign: TextAlign.center,
                style: AppTypography.body2.copyWith(
                  color: AppColors.grayScale_450,
                ),
              ),
              Padding(
                padding: AppSpacing.large28,
                child: ElevatedButton(
                  style: ButtonStyle(
                      minimumSize: WidgetStatePropertyAll(Size(150, 40)),
                      padding: WidgetStatePropertyAll(
                          EdgeInsets.symmetric(horizontal: 32, vertical: 12))),
                  onPressed: () {},
                  child: const Text('가이드 신청하기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
