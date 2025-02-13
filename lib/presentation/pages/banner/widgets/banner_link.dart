import 'package:flutter/material.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/presentation/pages/banner/widgets/banner_item_label.dart';
import 'package:wetravel/presentation/widgets/custom_input_field.dart';

class BannerLink extends StatelessWidget {
  /// 배너 링크
  const BannerLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // BannerItemLabel(label: '링크'),
          // SizedBox(height: 8),
          // SizedBox(
          //   height: 52,
          //   child: TextField(
          //     decoration: InputDecoration(
          //       enabledBorder: OutlineInputBorder(
          //         borderSide: BorderSide(
          //           color: AppColors.grayScale_150,
          //           width: 1,
          //         ),
          //         borderRadius: BorderRadius.circular(12),
          //       ),
          //     ),
          //   ),
          // ),
          CustomInputField(
            keyboardType: TextInputType.text,
            hintText: '',
            maxLength: 200,
            labelText: '링크',
            validator: (value) =>
                value == null || value.trim().isEmpty ? '설명을 입력해주세요.' : null,
          )
        ],
      ),
    );
  }
}
