import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_shadow.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/core/constants/app_colors.dart';

class TermsAndPrivacyBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        const url =
            'https://weetravel.notion.site/188e73dd935881a8af01f4f12db0d7c9';
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      },
      child: _buildBoxContainer('이용약관/개인정보 처리방침'),
    );
  }

  Widget _buildBoxContainer(String label) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppBorderRadius.small12,
        boxShadow: AppShadow.generalShadow,
      ),
      child: Row(
        children: [
          Text(label,
              style:
                  AppTypography.body2.copyWith(color: AppColors.grayScale_750)),
        ],
      ),
    );
  }
}
