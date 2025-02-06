import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/presentation/pages/guide/apply_complete_page.dart';
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
  bool? hasSubmittedPackage;

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

    if (isGuide == false) {
      await _checkIfUserHasSubmittedPackage(user.id);
    }
  }

  Future<void> _checkIfUserHasSubmittedPackage(String userId) async {
    try {
      final packageSnapshot = await FirebaseFirestore.instance
          .collection('packages')
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      setState(() {
        hasSubmittedPackage = packageSnapshot.docs.isNotEmpty;
      });
    } catch (e) {
      print("Error fetching package: $e");
      setState(() {
        hasSubmittedPackage = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isGuide == null || hasSubmittedPackage == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: isGuide!
          ? GuidePackageListPage() // 가이드인 경우 내가 등록한 패키지 리스트 페이지
          : hasSubmittedPackage!
              ? ApplicationCompletePage() // 신청 완료 페이지
              : GuideApplyPage(), // 가이드가 아니고, 패키지가 없으면 신청페이지
    );
  }
}
