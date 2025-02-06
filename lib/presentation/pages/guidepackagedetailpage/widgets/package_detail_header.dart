import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_icons.dart';
import 'package:wetravel/core/constants/app_typography.dart';

class PackageDetailHeader extends StatelessWidget {
  final String title;
  final List<String> keywordList;
  final String location;
  final String? userImageUrl; // 작성자 프로필 이미지
  final String? userName; // 작성자 이름
  final Function(String, List<String>, String) onUpdate;

  const PackageDetailHeader({
    super.key,
    required this.title,
    required this.keywordList,
    required this.location,
    this.userImageUrl,
    this.userName,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    List<String?> selectedKeywords =
        keywordList.isNotEmpty ? List.from(keywordList) : [null, null, null];

    return Container(
      width: double.infinity,
      height: 156,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: ShapeDecoration(
                    image: DecorationImage(
                      image: (userImageUrl != null &&
                              userImageUrl!.startsWith('http'))
                          ? NetworkImage(userImageUrl!)
                          : const AssetImage('assets/images/sample_profile.jpg')
                              as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppBorderRadius.small12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    userName ?? '작성자 없음',
                    style: AppTypography.body2.copyWith(
                      color: AppColors.grayScale_950,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: Text(
              title,
              style: AppTypography.headline2.copyWith(
                color: AppColors.grayScale_950,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    children: selectedKeywords
                        .asMap()
                        .entries
                        .map((entry) {
                          final index = entry.key;
                          final keyword = entry.value ?? '키워드 ${index + 1}';
                          return [
                            Text(
                              keyword,
                              style: AppTypography.body2.copyWith(
                                color: AppColors.grayScale_550,
                              ),
                            ),
                            if (index < selectedKeywords.length - 1)
                              const SizedBox(width: 8),
                          ];
                        })
                        .expand((widget) => widget)
                        .toList(),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    SvgPicture.asset(
                      AppIcons.mapPin,
                      color: AppColors.grayScale_550,
                      height: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      location,
                      style: AppTypography.body2.copyWith(
                        color: AppColors.grayScale_550,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
