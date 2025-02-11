import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/domain/usecase/delete_account_usecase.dart';
import 'package:wetravel/presentation/provider/user_provider.dart'; // UseCase Provider import

class DeleteAccountButton extends ConsumerWidget {
  const DeleteAccountButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deleteAccountUseCase = ref.read(deleteAccountUseCaseProvider); // UseCase Provider 읽기

    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: GestureDetector(
        onTap: () {
          _showDeleteAccountDialog(context, deleteAccountUseCase); // 다이얼로그 표시
        },
        child: Text(
          '회원탈퇴',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, DeleteAccountUseCase deleteAccountUseCase) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return CupertinoAlertDialog(
          title: const Text('회원탈퇴'),
          content: const Text('정말로 회원 탈퇴를 진행하시겠습니까? 이 작업은 되돌릴 수 없습니다.'),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('취소'),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () async {
                try {
                  await deleteAccountUseCase.execute(); // UseCase 실행
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                } catch (e) {
                  // 에러 처리: 스낵바 등을 사용하여 사용자에게 알림
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('회원 탈퇴에 실패했습니다: $e')),
                  );
                  Navigator.of(dialogContext).pop(); // 다이얼로그 닫기
                }
              },
              child: const Text('탈퇴'),
            ),
          ],
        );
      },
    );
  }
}