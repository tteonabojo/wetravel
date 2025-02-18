import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/presentation/pages/admin/admin_page.dart';
import 'package:wetravel/core/constants/app_icons.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_shadow.dart';
import 'package:wetravel/core/constants/app_typography.dart';

class AdminBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => AdminPage())),
      child: _buildBoxContainer('패키지 관리', icon: AppIcons.noteSearch),
    );
  }

  Widget _buildBoxContainer(String label, {String? icon}) {
    return Column(
      children: [
        SizedBox(height: 8),
        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppBorderRadius.small12,
            boxShadow: AppShadow.generalShadow,
          ),
          child: Row(
            children: [
              if (icon != null)
                SvgPicture.asset(icon,
                    height: 20, color: AppColors.grayScale_550),
              SizedBox(width: icon != null ? 8 : 0),
              Text(label,
                  style: AppTypography.body2
                      .copyWith(color: AppColors.grayScale_750)),
            ],
          ),
        ),
      ],
    );
  }
}
