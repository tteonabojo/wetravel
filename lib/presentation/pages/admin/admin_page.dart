import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/presentation/pages/admin/widgets/filter_buttons.dart';
import 'package:wetravel/presentation/pages/admin/widgets/package_list.dart';

class AdminPage extends ConsumerWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '패키지 관리',
          style:
              AppTypography.headline4.copyWith(color: AppColors.grayScale_950),
        ),
      ),
      body: Column(
        children: [
          FilterButtons(),
          Expanded(
            child: PackageList(),
          ),
        ],
      ),
    );
  }
}
