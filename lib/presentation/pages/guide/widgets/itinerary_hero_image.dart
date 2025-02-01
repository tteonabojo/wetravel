import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_icons.dart';
import 'package:wetravel/core/constants/app_spacing.dart';

class ItineraryHeroImage extends StatelessWidget {
  final String imagePath;
  final ValueChanged<String> onImageSelected;

  const ItineraryHeroImage({
    super.key,
    this.imagePath = "assets/images/cherry_blossom.png",
    required this.onImageSelected,
  });

  void _selectImage() {
    final newImagePath = "assets/images/mountain_view.png";
    onImageSelected(newImagePath);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _selectImage,
      child: Container(
        width: double.infinity,
        height: 260,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
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
                padding: AppSpacing.small4,
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
