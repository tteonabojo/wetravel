import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_shadow.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/core/constants/app_colors.dart';

class InquiryBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showInquiryDialog(context),
      child: _buildBoxContainer('문의하기'),
    );
  }

  void _showInquiryDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text('문의하기',
            style:
                AppTypography.body2.copyWith(color: AppColors.grayScale_750)),
        content: Text('관리자 이메일: ksh20531@gmail.com'),
        actions: [
          CupertinoDialogAction(
              child: Text('확인'), onPressed: () => Navigator.pop(context)),
        ],
      ),
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
