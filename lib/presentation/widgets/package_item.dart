import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_icons.dart';
import 'package:wetravel/core/constants/app_shadow.dart';
import 'package:wetravel/core/constants/app_spacing.dart';
import 'package:wetravel/core/constants/app_typography.dart';

class PackageItem extends StatelessWidget {
  final Widget? icon; // 아이콘 커스터마이징
  final VoidCallback? onIconTap; // 아이콘 클릭 동작
  final int? rate;
  final String title;
  final String location;
  final String? guideImageUrl;
  final String? packageImageUrl;
  final String? name;
  final List<String> keywords;

  const PackageItem({
    super.key,
    this.icon,
    this.onIconTap,
    this.rate,
    required this.title,
    required this.location,
    this.guideImageUrl,
    this.packageImageUrl,
    this.name,
    required this.keywords,
  });

  @override
  Widget build(BuildContext context) {
    assert(keywords.length == 3, "키워드 리스트는 반드시 3개의 요소를 가져야 합니다.");

    return Container(
      width: 312,
      height: 120,
      padding: AppSpacing.medium16,
      decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: AppBorderRadius.small12,
          ),
          shadows: AppShadow.generalShadow),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageAndRating(),
          icon != null ? _buildCustomIcon() : SizedBox.shrink(),
        ],
      ),
    );
  }

  Expanded _buildImageAndRating() {
    return Expanded(
      child: SizedBox(
        height: 88,
        child: Row(
          spacing: 12,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: ShapeDecoration(
                      image:
                          packageImageUrl != null && packageImageUrl!.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(packageImageUrl!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppBorderRadius.small8,
                      ),
                    ),
                    child:
                        packageImageUrl != null && packageImageUrl!.isNotEmpty
                            ? _buildImageWithLoader(packageImageUrl!)
                            : Container(),
                  ),
                ),
                rate != null ? _buildRatingBadge() : SizedBox.shrink(),
              ],
            ),
            _buildPackageDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWithLoader(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8), // 모서리를 둥글게 할 반경 설정
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child; // 이미지가 로드되면 실제 이미지를 반환
          } else {
            return Center(
              child: SizedBox(
                width: 20, // 로딩 인디케이터의 크기 가로 20
                height: 20, // 로딩 인디케이터의 크기 세로 20
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          (loadingProgress.expectedTotalBytes ?? 1)
                      : null,
                  strokeWidth: 2, // 로딩 인디케이터의 두께 조정
                ),
              ),
            );
          }
        },
        errorBuilder: (context, error, stackTrace) {
          return Center(
              child: Icon(Icons.error, color: Colors.red)); // 로딩 실패 시 에러 아이콘 표시
        },
      ),
    );
  }

  Widget _buildRatingBadge() {
    return Container(
      height: 28,
      width: 28,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        color: Colors.black.withOpacity(0.5),
      ),
      child: Center(
        child: Text(
          '$rate',
          style: AppTypography.headline6.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  Expanded _buildPackageDetails() {
    return Expanded(
      child: SizedBox(
        height: double.infinity,
        child: Column(
          spacing: 2,
          children: [
            SizedBox(
              width: double.infinity,
              height: 24,
              child: Text(
                title,
                style: AppTypography.headline5,
              ),
            ),
            _buildPackageInfo(),
            _buildGuideInfo(),
          ],
        ),
      ),
    );
  }

  SizedBox _buildPackageInfo() {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Row(
              spacing: 8,
              children: [
                Text(
                  keywords.isNotEmpty ? keywords[0] : '2박 3일', // 첫 번째 키워드
                  style: AppTypography.body3.copyWith(
                    color: AppColors.grayScale_650,
                  ),
                ),
                _separator(),
                Text(
                  keywords.length > 1 ? keywords[1] : '혼자', // 두 번째 키워드
                  style: AppTypography.body3.copyWith(
                    color: AppColors.grayScale_650,
                  ),
                ),
                _separator(),
                Text(
                  keywords.length > 2 ? keywords[2] : '액티비티', // 세 번째 키워드
                  style: AppTypography.body3.copyWith(
                    color: AppColors.grayScale_650,
                  ),
                ),
              ],
            ),
          ),
          _buildLocationInfo(),
        ],
      ),
    );
  }

  SizedBox _buildLocationInfo() {
    return SizedBox(
      width: double.infinity,
      child: Row(
        spacing: 2,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                AppIcons.mapPin,
                width: 12,
                color: AppColors.grayScale_550,
              ),
            ],
          ),
          Expanded(
            child: SizedBox(
              child: Text(
                location,
                style: AppTypography.body3.copyWith(
                  color: AppColors.grayScale_650,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _buildGuideInfo() {
    return SizedBox(
      width: double.infinity,
      child: Row(
        spacing: 6,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: ShapeDecoration(
              image: DecorationImage(
                image: guideImageUrl != null && guideImageUrl!.isNotEmpty
                    ? NetworkImage(guideImageUrl!)
                    : AssetImage("assets/images/sample_profile.jpg")
                        as ImageProvider,
                fit: BoxFit.cover,
              ),
              shape: CircleBorder(),
            ),
          ),
          Expanded(
            child: SizedBox(
              child: Text(name!,
                  style: AppTypography.body3.copyWith(
                    color: AppColors.grayScale_750,
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomIcon() {
    return GestureDetector(
      onTap: onIconTap,
      child: icon ??
          SvgPicture.asset(
            AppIcons.trash,
            width: 20,
            height: 20,
            color: AppColors.grayScale_550,
          ),
    );
  }
}

Container _separator() {
  return Container(
    width: 1,
    height: 8,
    decoration: BoxDecoration(color: AppColors.grayScale_550),
  );
}
