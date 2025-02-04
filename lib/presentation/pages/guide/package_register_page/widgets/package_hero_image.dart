import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
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
      // 이미지 리사이즈
      final resizedImage = await _resizeImage(pickedFile);

      setState(() {
        _currentImagePath = resizedImage.path;
      });

      widget.onImageSelected(resizedImage.path);
    }
  }

  Future<File> _resizeImage(XFile pickedFile) async {
    final imageBytes = await pickedFile.readAsBytes();
    final image = img.decodeImage(Uint8List.fromList(imageBytes));

    if (image != null) {
      final resizedImage = img.copyResize(image, width: 500);

      final resizedFile = File(pickedFile.path)
        ..writeAsBytesSync(img.encodeJpg(resizedImage));
      return resizedFile;
    }

    throw Exception('이미지 리사이즈 실패');
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
                  image: _currentImagePath!.startsWith('http')
                      ? NetworkImage(_currentImagePath!)
                      : FileImage(File(_currentImagePath!)) as ImageProvider,
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
                shape: const CircleBorder(),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4),
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
