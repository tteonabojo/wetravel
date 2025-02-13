import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_icons.dart';
import 'package:wetravel/core/constants/app_typography.dart';

class BannerImage extends StatefulWidget {
  /// 배너 이미지
  const BannerImage({super.key});

  @override
  State<BannerImage> createState() => _BannerImageState();
}

class _BannerImageState extends State<BannerImage> {
  XFile? file;

  /// 배너 이미지 선택
  Future<void> _pickImage() async {
    ImagePicker().pickImage(source: ImageSource.gallery).then((image) {
      if (image != null) {
        setState(() {
          file = image;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      width: double.infinity,
      decoration: BoxDecoration(color: AppColors.grayScale_150),
      child: Stack(
        children: [
          (file == null)
              ? Center(
                  child: Text(
                    '이미지를 설정해주세요',
                    style: AppTypography.body3.copyWith(
                      color: AppColors.grayScale_450,
                    ),
                  ),
                )
              : Image.file(
                  height: 260,
                  width: double.infinity,
                  File(file!.path),
                  fit: BoxFit.cover,
                ),
          Positioned(
            bottom: 16,
            right: 16,
            child: GestureDetector(
              onTap: () => _pickImage(),
              child: Container(
                height: 28,
                width: 28,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: AppColors.grayScale_450,
                ),
                child: Center(
                    child: SvgPicture.asset(
                  AppIcons.camera,
                  color: Colors.white,
                  width: 16,
                  height: 16,
                )),
              ),
            ),
          )
        ],
      ),
    );
  }
}
