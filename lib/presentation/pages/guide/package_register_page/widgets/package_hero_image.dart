import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_icons.dart';
import 'package:wetravel/core/constants/app_spacing.dart';

class PackageHeroImage extends StatefulWidget {
  final String? imagePath;
  final ValueChanged<String> onImageSelected;

  const PackageHeroImage({
    super.key,
    this.imagePath,
    required this.onImageSelected,
  });

  @override
  State<PackageHeroImage> createState() => _PackageHeroImageState();
}

class _PackageHeroImageState extends State<PackageHeroImage> {
  String? _currentImagePath;

  @override
  void initState() {
    super.initState();
    _currentImagePath = widget.imagePath;
  }

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _currentImagePath = pickedFile.path;
      });
      widget.onImageSelected(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _selectImage,
      child: Container(
        width: double.infinity,
        height: 260,
        padding: AppSpacing.medium16,
        decoration: BoxDecoration(
          color: AppColors.grayScale_150,
          image: _currentImagePath != null && _currentImagePath!.isNotEmpty
              ? DecorationImage(
                  image: _currentImagePath!.startsWith('assets')
                      ? AssetImage(_currentImagePath!) as ImageProvider
                      : FileImage(File(_currentImagePath!)),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: ShapeDecoration(
                color: AppColors.grayScale_450,
                shape: CircleBorder(),
              ),
              child: Padding(
                padding: EdgeInsets.all(4),
                child: SvgPicture.asset(
                  AppIcons.camera,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
