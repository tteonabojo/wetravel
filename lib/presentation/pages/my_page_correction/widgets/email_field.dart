import 'package:flutter/material.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/presentation/provider/my_page_correction_provider.dart';

class EmailFieldWidget extends ConsumerWidget {
  const EmailFieldWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myPageCorrectionViewModelProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('이메일 주소',
            style: AppTypography.headline6
                .copyWith(color: AppColors.grayScale_650)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
              color: AppColors.grayScale_150,
              borderRadius: BorderRadius.circular(12)),
          child: Text(state.userEmail ?? '이메일 정보 없음',
              style:
                  AppTypography.body1.copyWith(color: AppColors.grayScale_550)),
        ),
      ],
    );
  }
}