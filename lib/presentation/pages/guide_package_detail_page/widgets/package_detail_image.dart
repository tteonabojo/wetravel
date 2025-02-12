import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_spacing.dart';

class PackageDetailImage extends StatefulWidget {
  final String? imagePath;
  final ValueChanged<String> onImageSelected;

  const PackageDetailImage({
    super.key,
    this.imagePath,
    required this.onImageSelected,
  });

  @override
  State<PackageDetailImage> createState() => _PackageHeroImageState();
}

class _PackageHeroImageState extends State<PackageDetailImage> {
  String? _currentImagePath;

  @override
  void initState() {
    super.initState();
    _currentImagePath = widget.imagePath;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 260,
      padding: AppSpacing.medium16,
      decoration: BoxDecoration(
        color: AppColors.grayScale_150,
        image: _currentImagePath != null && _currentImagePath!.isNotEmpty
            ? DecorationImage(
                image: _currentImagePath!.startsWith('http')
                    ? NetworkImage(_currentImagePath!)
                    : FileImage(File(_currentImagePath!)) as ImageProvider,
                fit: BoxFit.cover,
              )
            : null,
      ),
    );
  }
}
