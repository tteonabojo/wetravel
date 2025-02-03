import 'package:flutter/material.dart';
import 'package:wetravel/presentation/pages/guide/guide_apply_page.dart';
import 'package:wetravel/presentation/pages/guide/guide_package_list_page.dart';

class GuidePage extends StatefulWidget {
  final bool isGuide;

  const GuidePage({
    super.key,
    required this.isGuide,
  });

  @override
  _GuidePageState createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.isGuide
          ? GuidePackageListPage() // 가이드인 경우 내가 등록한 패키지 리스트 페이지
          : GuideApplyPage(), // 가이드가 아닌경우 신청페이지
    );
  }
}
