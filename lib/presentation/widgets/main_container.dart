import 'package:flutter/material.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_shadow.dart';
import 'package:wetravel/core/constants/app_spacing.dart';
import 'package:wetravel/core/constants/app_typography.dart';

class CardAiMainContainer extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final List<String> tags;

  const CardAiMainContainer({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 252,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            shadows: AppShadow.generalShadow,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageContainer(imagePath),
              _buildTextContainer(title, description),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageContainer(String imagePath) {
    return Container(
      width: double.infinity,
      height: 168,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.fitWidth,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Tag(tags: tags),
        ),
      ),
    );
  }

  Widget _buildTextContainer(String title, String description) {
    return Container(
      width: double.infinity,
      height: 84,
      padding: AppSpacing.medium16,
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: AppTypography.headline3.copyWith(
                color: AppColors.grayScale_950,
              )),
          Text(description,
              style: AppTypography.body2.copyWith(
                color: AppColors.grayScale_450,
              )),
        ],
      ),
    );
  }
}

class Tag extends StatelessWidget {
  final List<String> tags;

  const Tag({super.key, required this.tags});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: tags.map((tag) => _buildTagItem(tag)).toList(),
    );
  }

  Widget _buildTagItem(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: ShapeDecoration(
        color: AppColors.grayScale_950.withOpacity(0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(text,
          textAlign: TextAlign.center,
          style: AppTypography.buttonLabelXSmall.copyWith(color: Colors.white)),
    );
  }
}
