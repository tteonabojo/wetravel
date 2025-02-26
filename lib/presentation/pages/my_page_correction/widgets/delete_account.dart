import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/app_spacing.dart';
import 'package:wetravel/presentation/pages/my_page_correction/mypage_correction_view_model.dart';
import 'package:wetravel/presentation/provider/my_page_correction_provider.dart';

class DeleteAccountWidget extends ConsumerWidget {
  const DeleteAccountWidget({super.key});

  void _showDeleteAccountDialog(
      BuildContext context, WidgetRef ref, MyPageCorrectionViewModel viewModel) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return CupertinoAlertDialog(
          title: const Text('회원탈퇴'),
          content: const Text('탈퇴 확인을 위해 재인증이 필요합니다.\n이 작업은 되돌릴 수 없습니다.'),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('취소'),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await viewModel.deleteAccount(context);
              },
              child: const Text('탈퇴'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(myPageCorrectionViewModelProvider.notifier);
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: AppSpacing.medium16,
        child: GestureDetector(
          onTap: () {
            _showDeleteAccountDialog(context, ref, viewModel);
          },
          child: Text(
            '회원탈퇴',
            style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                decoration: TextDecoration.underline),
          ),
        ),
      ),
    );
  }
}