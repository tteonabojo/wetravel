import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/presentation/pages/my_page_correction/mypage_correction_view_model.dart';
import 'package:wetravel/presentation/provider/my_page_correction_provider.dart';

class SaveButtonWidget extends ConsumerWidget {
  const SaveButtonWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(myPageCorrectionViewModelProvider.notifier);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: viewModel.isFormValid
            ? AppColors.primary_450
            : AppColors.primary_250,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      onPressed: viewModel.isFormValid ? () => viewModel.saveUserInfo(context) : null,
      child: const Text('등록',
          style: TextStyle(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }
}