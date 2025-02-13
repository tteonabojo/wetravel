import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/presentation/pages/banner/widgets/banner_item_label.dart';

class BannerOrder extends StatelessWidget {
  /// 배너 순서
  const BannerOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BannerItemLabel(label: '노출 순서'),
          SizedBox(
            width: 56,
            child: TextField(
              controller: TextEditingController(),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              style:
                  AppTypography.body1.copyWith(color: AppColors.grayScale_350),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.grayScale_150),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.grayScale_150),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.grayScale_150),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
