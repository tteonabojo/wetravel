import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/presentation/pages/my_page_correction/mypage_correction_view_model.dart';
import 'package:wetravel/presentation/provider/my_page_correction_provider.dart';

class ProfileImageWidget extends ConsumerWidget {
  const ProfileImageWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(myPageCorrectionViewModelProvider.notifier);
    final state = ref.watch(myPageCorrectionViewModelProvider);
    bool isValidUrl =
        viewModel.imageUrl != null && viewModel.imageUrl!.startsWith('http');
    bool hasTempImage = viewModel.tempImageFile != null;

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
                  image: hasTempImage
                      ? DecorationImage(
                          image: FileImage(viewModel.tempImageFile!),
                          fit: BoxFit.cover,
                        )
                      : isValidUrl
                          ? DecorationImage(
                              image: NetworkImage(viewModel.imageUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                ),
                child: !hasTempImage && !isValidUrl
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
}