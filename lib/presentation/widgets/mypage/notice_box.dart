import 'package:flutter/material.dart';
import 'package:wetravel/core/constants/app_shadow.dart';

class NoticeBox extends StatelessWidget {
  const NoticeBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppShadow.generalShadow,
      ),
      child: const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          '공지사항',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}