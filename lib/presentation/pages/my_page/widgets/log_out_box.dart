import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_shadow.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/presentation/provider/user_provider.dart';

class LogoutBox extends StatelessWidget {
  final WidgetRef ref;
  LogoutBox({required this.ref});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final signOutUsecase = ref.read(signOutUsecaseProvider);
        await signOutUsecase.signOut();

        if (context.mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      },
      child: _buildBoxContainer('로그아웃'),
    );
  }

  Widget _buildBoxContainer(String label, {String? icon}) {
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
          if (icon != null)
            SvgPicture.asset(icon, height: 20, color: AppColors.grayScale_550),
          SizedBox(width: icon != null ? 8 : 0),
          Text(label,
              style:
                  AppTypography.body2.copyWith(color: AppColors.grayScale_750)),
        ],
      ),
    );
  }
}
