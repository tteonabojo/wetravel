import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_icons.dart';
import 'package:wetravel/core/constants/app_shadow.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/domain/entity/package.dart';
import 'package:wetravel/presentation/pages/admin/admin_page_view_model.dart';
import 'package:wetravel/presentation/pages/guide/package_edit_page/package_edit_page.dart';
import 'package:wetravel/presentation/pages/guide_package_detail_page/package_detail_page.dart';
import 'package:wetravel/presentation/provider/package_provider.dart';
import 'package:wetravel/presentation/widgets/package_item.dart';

class PackageListItem extends ConsumerWidget {
  final Package package;

  const PackageListItem({super.key, required this.package});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: _buildBoxDecoration(),
      child: GestureDetector(
        onTap: () => _navigateToDetailPage(context),
        child: PackageItem(
          icon: SvgPicture.asset(AppIcons.ellipsisVertical),
          onIconTap: () => _showPackageOptions(context, ref),
          packageImageUrl: package.imageUrl,
          title: package.title,
          keywords: package.keywordList!,
          location: package.location,
          guideImageUrl: package.userImageUrl,
          name: package.userName,
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return BoxDecoration(
      boxShadow: AppShadow.generalShadow,
      borderRadius: AppBorderRadius.small12,
      color: Colors.white,
    );
  }

  void _navigateToDetailPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PackageDetailPage(packageId: package.id),
      ),
    );
  }

  void _showPackageOptions(BuildContext context, WidgetRef ref) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(
          package.title,
          style:
              AppTypography.headline4.copyWith(color: AppColors.grayScale_950),
        ),
        actions: _buildActionSheetActions(context, ref),
        cancelButton: _buildCancelButton(context),
      ),
    );
  }

  List<CupertinoActionSheetAction> _buildActionSheetActions(
      BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(adminPageViewModelProvider.notifier);

    return [
      CupertinoActionSheetAction(
        onPressed: () => _navigateToEditPage(context),
        child: _buildActionText('수정', AppColors.primary_550),
      ),
      CupertinoActionSheetAction(
        onPressed: () async => _toggleVisibility(context, viewModel),
        child: _buildActionText(
          package.isHidden ? '공개 전환' : '비공개 전환',
          package.isHidden ? AppColors.primary_550 : AppColors.red,
        ),
      ),
      CupertinoActionSheetAction(
        onPressed: () async => _deletePackage(context, ref, viewModel),
        isDestructiveAction: true,
        child: _buildActionText('삭제', AppColors.red),
      ),
    ];
  }

  CupertinoActionSheetAction _buildCancelButton(BuildContext context) {
    return CupertinoActionSheetAction(
      onPressed: () => Navigator.pop(context),
      child: _buildActionText('취소', AppColors.grayScale_550),
    );
  }

  Text _buildActionText(String text, Color color) {
    return Text(text,
        style: AppTypography.buttonLabelNormal.copyWith(color: color));
  }

  void _navigateToEditPage(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PackageEditPage(packageId: package.id),
      ),
    );
  }

  Future<void> _toggleVisibility(
      BuildContext context, AdminPageViewModel viewModel) async {
    Navigator.pop(context);
    await viewModel.toggleIsHidden(package.id, package.isHidden);
  }

  Future<void> _deletePackage(
      BuildContext context, WidgetRef ref, AdminPageViewModel viewModel) async {
    Navigator.pop(context);
    await viewModel.deletePackage(package.id);
    ref.invalidate(fetchUserPackagesUsecaseProvider);
  }
}
