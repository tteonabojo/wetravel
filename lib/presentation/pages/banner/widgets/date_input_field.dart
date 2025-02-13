import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_typography.dart';

class DateInputField extends StatelessWidget {
  final DateTime date;
  final VoidCallback onTap;

  DateInputField({
    super.key,
    required this.date,
    required this.onTap,
  });

  final dateFormat = DateFormat('yyyy.MM.dd');

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: TextField(
        readOnly: true,
        controller: TextEditingController(
          text: dateFormat.format(date),
        ),
        onTap: onTap,
        style: AppTypography.body1.copyWith(color: AppColors.grayScale_350),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
    );
  }
}
