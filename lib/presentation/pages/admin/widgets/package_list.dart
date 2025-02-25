import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_spacing.dart';
import 'package:wetravel/presentation/pages/admin/admin_page_view_model.dart';
import 'package:wetravel/presentation/pages/admin/widgets/package_list_item.dart';

class PackageList extends ConsumerStatefulWidget {
  const PackageList({super.key});

  @override
  _PackageListState createState() => _PackageListState();
}

class _PackageListState extends ConsumerState<PackageList> {
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(adminPageViewModelProvider);

    if (viewModel.isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: AppColors.primary_450,
        ),
      );
    }

    if (viewModel.errorMessage != null) {
      return Center(child: Text('오류 발생: ${viewModel.errorMessage}'));
    }

    final filteredPackages = viewModel.getFilteredPackages();

    if (filteredPackages.isEmpty) {
      return Center(child: Text('등록된 패키지가 없습니다.'));
    }

    return ListView.builder(
      padding: AppSpacing.medium16,
      itemCount: filteredPackages.length,
      itemBuilder: (context, index) {
        final package = filteredPackages[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: PackageListItem(package: package),
        );
      },
    );
  }
}
