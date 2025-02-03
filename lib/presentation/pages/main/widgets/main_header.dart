import 'package:flutter/material.dart';
import 'package:wetravel/core/constants/app_colors.dart';

class MainHeader extends StatelessWidget {
  /// 메인 페이지 로고 영역
  const MainHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: double.infinity,
      color: AppColors.grayScale_050,
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
            child: Icon(Icons.airplanemode_active),
          ),
          Text('LOGO'),
        ],
      ),
    );
  }
}
