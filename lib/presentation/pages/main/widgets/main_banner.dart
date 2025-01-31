import 'package:flutter/material.dart';

class MainBanner extends StatelessWidget {
  /// 메인 페이지 배너 영역
  const MainBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      width: double.infinity,
      color: Colors.black45,
      child: Center(
        child: Text('banner'),
      ),
    );
  }
}
