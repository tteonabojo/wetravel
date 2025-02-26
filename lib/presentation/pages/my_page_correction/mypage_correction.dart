import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/presentation/pages/my_page_correction/mypage_correction_view_model.dart';
import 'package:wetravel/presentation/provider/my_page_correction_provider.dart';
import 'package:wetravel/presentation/widgets/custom_input_field.dart';
import 'package:wetravel/presentation/pages/my_page_correction/widgets/profile_image.dart';
import 'package:wetravel/presentation/pages/my_page_correction/widgets/email_field.dart';
import 'package:wetravel/presentation/pages/my_page_correction/widgets/delete_account.dart';
import 'package:wetravel/presentation/pages/my_page_correction/widgets/save_button.dart';

class MyPageCorrection extends ConsumerStatefulWidget {
  const MyPageCorrection({super.key});

  @override
  ConsumerState<MyPageCorrection> createState() => _MyPageCorrectionState();
}

class _MyPageCorrectionState extends ConsumerState<MyPageCorrection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(myPageCorrectionViewModelProvider.notifier).initialize();
    });
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
  }

  Future<bool> _showExitConfirmationDialog() async {
    return await showCupertinoDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            '프로필 설정에서 나가시겠어요?',
            style: AppTypography.headline6.copyWith(
              fontSize: 18,
              color: AppColors.grayScale_950,
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '변경사항이 저장되지 않아요.',
              style: AppTypography.body2.copyWith(
                fontSize: 14,
                color: AppColors.grayScale_650,
              ),
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                '취소',
                style: AppTypography.body1.copyWith(
                  color: AppColors.primary_450,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(true),
              isDestructiveAction: true,
              child: Text(
                '나가기',
                style: AppTypography.body1.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    ).then((value) => value ?? false);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(myPageCorrectionViewModelProvider.notifier);
    final state = ref.watch(myPageCorrectionViewModelProvider);

    return WillPopScope(
      onWillPop: () async {
        if (state.isChanged) {
          return await _showExitConfirmationDialog();
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () async {
              if (state.isChanged) {
                if (await _showExitConfirmationDialog()) {
                  Navigator.pop(context);
                }
              } else {
                Navigator.pop(context);
              }
            },
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const ProfileImageWidget(), // 프로필 이미지 위젯
              const SizedBox(height: 20),
              CustomInputField(
                counterAlignment: Alignment.centerRight,
                controller: viewModel.nameController,
                hintText: state.name.isNotEmpty ? state.name : '닉네임을 입력하세요.',
                maxLength: 15,
                labelText: '닉네임',
                onChanged: (value) => viewModel.setName(value),
              ),
              const SizedBox(height: 12),
              const EmailFieldWidget(), // 이메일 필드 위젯
              const SizedBox(height: 20),
              CustomInputField(
                counterAlignment: Alignment.centerRight,
                controller: viewModel.introController,
                hintText: '멋진 소개를 부탁드려요!',
                maxLength: 100,
                labelText: '자기소개',
                minLines: 6,
                maxLines: 6,
                onChanged: (value) => viewModel.setIntro(value),
              ),
              const SizedBox(height: 8),
              const DeleteAccountWidget(), // 회원 탈퇴 위젯
            ],
          ),
        ),
        bottomNavigationBar: const Padding(
          padding: EdgeInsets.only(bottom: 42, left: 16, right: 16),
          child: SaveButtonWidget(), // 저장 버튼 위젯
        ),
      ),
    );
  }
}