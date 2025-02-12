import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_icons.dart';
import 'package:wetravel/core/constants/app_spacing.dart';
import 'package:wetravel/core/constants/app_typography.dart';

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
  late String? _currentImagePath = widget.imagePath;

  bool get hasImage =>
      _currentImagePath != null && _currentImagePath!.isNotEmpty;

  Future<void> _selectImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    final resizedImage = await _resizeImage(pickedFile);

    setState(() => _currentImagePath = resizedImage.path);
    widget.onImageSelected(resizedImage.path);
  }

  Future<File> _resizeImage(XFile pickedFile) async {
    final imageBytes = await pickedFile.readAsBytes();
    final image = img.decodeImage(Uint8List.fromList(imageBytes));

    if (image == null) throw Exception('이미지 리사이즈 실패');

    final resizedImage = img.copyResize(image, width: 400);
    return File(pickedFile.path)..writeAsBytesSync(img.encodeJpg(resizedImage));
  }

  ImageProvider getImageProvider() {
    if (_currentImagePath!.startsWith('http')) {
      return NetworkImage(_currentImagePath!);
    }
    return FileImage(File(_currentImagePath!));
  }

  Widget _buildCameraButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        width: 28,
        height: 28,
        decoration: const ShapeDecoration(
          color: AppColors.grayScale_450,
          shape: CircleBorder(),
        ),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: SvgPicture.asset(AppIcons.camera, color: Colors.white),
        ),
      ),
    );
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
          image: hasImage
              ? DecorationImage(image: getImageProvider(), fit: BoxFit.cover)
              : null,
        ),
        child: Stack(
          children: [
            if (!hasImage)
              Center(
                child: Text(
                  "이미지를 선택해주세요",
                  style: AppTypography.body3
                      .copyWith(color: AppColors.grayScale_450),
                ),
              ),
            _buildCameraButton(),
          ],
        ),
      ),
    );
  }
}
