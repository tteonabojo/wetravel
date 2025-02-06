import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/presentation/pages/guide/guide_apply_page.dart';
import 'package:wetravel/presentation/pages/guide/guide_package_list_page.dart';
import 'package:wetravel/presentation/provider/user_provider.dart';

class GuidePage extends ConsumerStatefulWidget {
  const GuidePage({super.key});

  @override
  _GuidePageState createState() => _GuidePageState();
}

class _GuidePageState extends ConsumerState<GuidePage> {
  bool? isGuide;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadGuideStatus();
  }

  Future<void> _loadGuideStatus() async {
    final fetchUserUsecase = ref.watch(fetchUserUsecaseProvider);
    final user = await fetchUserUsecase.execute();
    setState(() {
      isGuide = user.isGuide;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isGuide == null) {
      // 로딩 중
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: isGuide!
          ? GuidePackageListPage() // 가이드인 경우 내가 등록한 패키지 리스트 페이지
          : GuideApplyPage(), // 가이드가 아닌 경우 신청페이지
    );
  }
}
