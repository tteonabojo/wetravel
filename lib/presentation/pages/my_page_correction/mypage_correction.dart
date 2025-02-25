import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_spacing.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/presentation/pages/my_page_correction/mypage_correction_view_model.dart';
import 'package:wetravel/presentation/pages/my_page_correction/mypage_correction_view_model.dart';
import 'package:wetravel/presentation/provider/my_page_correction_provider.dart';
import 'package:wetravel/presentation/widgets/custom_input_field.dart';

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
              _buildProfileImage(viewModel),
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
              _buildEmailField(state.userEmail),
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
              _buildDeleteAccount(context, ref, viewModel),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 42, left: 16, right: 16),
          child: _buildSaveButton(viewModel),
        ),
      ),
    );
  }

  Widget _buildProfileImage(MyPageCorrectionViewModel viewModel) {
    bool isValidUrl =
        viewModel.imageUrl != null && viewModel.imageUrl!.startsWith('http');
    bool hasTempImage = viewModel.tempImageFile != null; // 임시 이미지 보여줌

    return Center(
      child: Stack(
        children: [
          GestureDetector(
            onTap: viewModel.pickImage,
            child: ClipOval(
              child: Container(
                width: 82,
                height: 82,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.primary_250,
                  image: hasTempImage // 임시 이미지 있을때
                      ? DecorationImage(
                          image: FileImage(viewModel.tempImageFile!),
                          fit: BoxFit.cover,
                        )
                      : isValidUrl // 기존 imageUrl 있을때
                          ? DecorationImage(
                               image: NetworkImage(viewModel.imageUrl!),
                               fit: BoxFit.cover,
                          )
                      : null,
                ),
                child: !hasTempImage && !isValidUrl // 수정중 이미지, 기존 이미지 없을때
                    ? const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 40,
                      )
                    : null,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: viewModel.pickImage,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
                child:
                    const Icon(Icons.camera_alt, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailField(String? email) {
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
          child: Text(email ?? '이메일 정보 없음', // email 그대로 표시
              style:
                  AppTypography.body1.copyWith(color: AppColors.grayScale_550)),
        ),
      ],
    );
  }

  Widget _buildDeleteAccount(
      BuildContext context, WidgetRef ref, MyPageCorrectionViewModel viewModel) {
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

  Widget _buildSaveButton(MyPageCorrectionViewModel viewModel) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: viewModel.isFormValid
        ? AppColors.primary_450
        : AppColors.primary_250,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 16),
    ),
    onPressed:
        viewModel.isFormValid? () => viewModel.saveUserInfo(context): null,
    child: const Text('등록',
        style: TextStyle(
            fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
  );
}
}