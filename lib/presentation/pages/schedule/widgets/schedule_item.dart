import 'package:flutter/material.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_shadow.dart';
import 'package:wetravel/core/constants/app_spacing.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/core/constants/app_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ScheduleItemWidget extends StatelessWidget {
  final String time;
  final String title;
  final String location;
  final bool isEditMode;
  final VoidCallback? onTap;
  final Key itemKey;

  const ScheduleItemWidget({
    required this.time,
    required this.title,
    required this.location,
    required this.isEditMode,
    required this.itemKey,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: itemKey,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppBorderRadius.small12,
        boxShadow: AppShadow.generalShadow,
      ),
      margin: const EdgeInsets.only(bottom: 12),
      padding: AppSpacing.medium16,
      child: Row(
        children: [
          Expanded(
            child: Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(time,
                    style: AppTypography.body2
                        .copyWith(color: AppColors.grayScale_950)),
                Text(title,
                    style: AppTypography.headline5
                        .copyWith(color: AppColors.grayScale_950)),
                Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.6),
                  child: Text(
                    location,
                    style: AppTypography.body2
                        .copyWith(color: AppColors.grayScale_650),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          if (isEditMode) ...[
            IconButton(
              icon: const Icon(Icons.edit, color: AppColors.grayScale_450),
              onPressed: onTap,
            ),
            const Icon(Icons.drag_handle, color: AppColors.grayScale_450),
          ],
        ],
      ),
    );
  }
}
