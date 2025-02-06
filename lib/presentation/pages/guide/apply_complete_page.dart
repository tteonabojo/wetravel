import 'package:flutter/material.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_typography.dart';

class ApplicationCompletePage extends StatelessWidget {
  const ApplicationCompletePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Text('가이드 신청 중',
                  textAlign: TextAlign.center,
                  style: AppTypography.headline3.copyWith(
                    color: AppColors.grayScale_950,
                  )),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: Text('관리자의 승인 후\n가이드 심사가 완료됩니다',
                  textAlign: TextAlign.center,
                  style: AppTypography.body2.copyWith(
                    color: AppColors.grayScale_450,
                  )),
            ),
          ],
        ),
      ],
    );
  }
}
