import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_icons.dart';
import 'package:wetravel/core/constants/app_shadow.dart';
import 'package:wetravel/core/constants/app_spacing.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/domain/entity/package.dart';
import 'package:wetravel/presentation/pages/admin/admin_page_view_model.dart';
import 'package:wetravel/presentation/pages/guide/package_edit_page/package_edit_page.dart';
import 'package:wetravel/presentation/pages/guide_package_detail_page/package_detail_page.dart';
import 'package:wetravel/presentation/provider/package_provider.dart';
import 'package:wetravel/presentation/widgets/package_item.dart';

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

class PackageListItem extends ConsumerWidget {
  final Package package;

  const PackageListItem({super.key, required this.package});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: AppShadow.generalShadow,
        borderRadius: AppBorderRadius.small12,
        color: Colors.white,
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PackageDetailPage(packageId: package.id),
            ),
          );
        },
        child: PackageItem(
          icon: SvgPicture.asset(AppIcons.ellipsisVertical),
          onIconTap: () {
            _showPackageOptions(context, ref, package);
          },
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

  void _showPackageOptions(
      BuildContext context, WidgetRef ref, Package package) {
    final viewModel = ref.read(adminPageViewModelProvider.notifier);
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(
          package.title,
          style:
              AppTypography.headline4.copyWith(color: AppColors.grayScale_950),
        ),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PackageEditPage(packageId: package.id),
                ),
              );
            },
            child: Text('수정',
                style: AppTypography.buttonLabelNormal
                    .copyWith(color: AppColors.primary_550)),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);
              await viewModel.toggleIsHidden(package.id, package.isHidden);
            },
            child: Text(
              package.isHidden ? '공개 전환' : '비공개 전환',
              style: AppTypography.buttonLabelNormal.copyWith(
                color: package.isHidden ? AppColors.primary_550 : AppColors.red,
              ),
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);
              await viewModel.deletePackage(package.id);
              ref.invalidate(fetchUserPackagesUsecaseProvider);
            },
            isDestructiveAction: true,
            child: Text('삭제',
                style: AppTypography.buttonLabelNormal
                    .copyWith(color: AppColors.red)),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: Text('취소',
              style: AppTypography.buttonLabelNormal
                  .copyWith(color: AppColors.grayScale_550)),
        ),
      ),
    );
  }
}
