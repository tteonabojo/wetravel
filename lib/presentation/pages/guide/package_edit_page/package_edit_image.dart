import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:wetravel/core/constants/app_animations.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_icons.dart';
import 'package:wetravel/core/constants/app_spacing.dart';

class PackageEditImage extends StatefulWidget {
  final String? initialImageUrl;
  final ValueChanged<String> onImageSelected;

  const PackageEditImage({
    super.key,
    this.initialImageUrl,
    required this.onImageSelected,
  });

  @override
  State<PackageEditImage> createState() => _PackageEditImageState();
}

class _PackageEditImageState extends State<PackageEditImage> {
  String? _currentImagePath;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentImagePath = widget.initialImageUrl;
  }

  Future<void> _selectImage() async {
    setState(() {
      isLoading = true;
    });

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final resizedImage = await _resizeImage(pickedFile);

      setState(() {
        _currentImagePath = resizedImage.path;
      });

      widget.onImageSelected(resizedImage.path);
    }

    setState(() {
      isLoading = false;
    });
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
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 4 / 3,
            child: Container(
              width: double.infinity,
              padding: AppSpacing.medium16,
              decoration: BoxDecoration(
                color: AppColors.grayScale_150,
                image:
                    _currentImagePath != null && _currentImagePath!.isNotEmpty
                        ? DecorationImage(
                            image: _currentImagePath!.startsWith('http')
                                ? NetworkImage(_currentImagePath!)
                                : FileImage(File(_currentImagePath!))
                                    as ImageProvider,
                            fit: BoxFit.cover,
                          )
                        : null,
              ),
            ),
          ),
          if (isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(child: AppAnimations.photoLoading),
              ),
            ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: AppColors.grayScale_450,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: SvgPicture.asset(
                  AppIcons.camera,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
