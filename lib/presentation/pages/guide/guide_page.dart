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
  bool? hasSubmittedPackage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
    final userAsyncValue = ref.watch(userStreamProvider);
    final isGuideAsyncValue = userAsyncValue.when(
      data: (data) {
        if (data != null && data.containsKey('isGuide')) {
          final isGuide = data['isGuide'] as bool?;
          if (isGuide == false) {
            final userId = data['id'];
            _checkIfUserHasSubmittedPackage(userId);
          }
          return isGuide;
        }
        return null;
      },
      loading: () => null,
      error: (_, __) => null,
    );

    if (isGuideAsyncValue == null || hasSubmittedPackage == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: isGuideAsyncValue!
          ? GuidePackageListPage() // 가이드인 경우 내가 등록한 패키지 리스트 페이지
          : hasSubmittedPackage!
              ? ApplicationCompletePage() // 신청 완료 페이지
              : GuideApplyPage(), // 가이드가 아니고, 패키지가 없으면 신청페이지
    );
  }
}
