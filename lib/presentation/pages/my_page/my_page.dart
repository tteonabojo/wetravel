import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/presentation/pages/my_page/widgets/admin_box.dart';
import 'package:wetravel/presentation/pages/my_page/widgets/inquiry_box.dart';
import 'package:wetravel/presentation/pages/my_page/widgets/log_out_box.dart';
import 'package:wetravel/presentation/pages/my_page/widgets/profile_box.dart';
import 'package:wetravel/presentation/pages/my_page/widgets/terms_and_privacy_box.dart';
import 'package:wetravel/presentation/provider/user_provider.dart';

class MyPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userStreamProvider);

    return Scaffold(
      body: userAsync.when(
        data: (userData) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              ProfileBox(userData: userData),
              if (userData?['isAdmin'] ?? false) AdminBox(),
              SizedBox(height: 8),
              InquiryBox(),
              SizedBox(height: 8),
              TermsAndPrivacyBox(),
              SizedBox(height: 8),
              LogoutBox(ref: ref),
            ],
          ),
        ),
        loading: () => Center(
            child: CircularProgressIndicator(color: AppColors.primary_450)),
        error: (error, stack) => Center(child: Text("오류 발생: $error")),
      ),
    );
  }
}
