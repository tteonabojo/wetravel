import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_icons.dart';
import 'package:wetravel/core/constants/app_shadow.dart';
import 'package:wetravel/core/constants/app_spacing.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/presentation/widgets/buttons/standard_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/app_routes.dart';
import 'package:wetravel/presentation/provider/new_trip_provider.dart';

class NewTripPage extends ConsumerWidget {
  const NewTripPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedPlansCount = ref.watch(savedPlansCountProvider);
    final savedGuidePlansCount = ref.watch(savedGuidePlansCountProvider);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMainCard(context),
            const SizedBox(height: 16),
            _buildSavedPlansButton(context, savedPlansCount.value ?? 0),
            const SizedBox(height: 16),
            _buildSavedGuidePlansButton(
                context, savedGuidePlansCount.value ?? 0),
          ],
        ),
      ),
    );
  }

  Widget _buildMainCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppBorderRadius.small12,
        color: Colors.white,
        boxShadow: AppShadow.generalShadow,
      ),
      child: Padding(
        padding: AppSpacing.medium16,
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              '쉽고 빠르게\n여행 일정을 만들어볼까요?',
              textAlign: TextAlign.center,
              style: AppTypography.headline4.copyWith(
                color: AppColors.grayScale_950,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '맞춤 AI와 가이드로 나만의 일정을 찾아드릴게요',
              textAlign: TextAlign.center,
              style: AppTypography.body3.copyWith(
                color: AppColors.grayScale_550,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: StandardButton.primary(
                sizeType: ButtonSizeType.normal,
                text: '새로운 여행 시작하기',
                onPressed: () => Navigator.pushNamed(
                  context,
                  AppRoutes.citySelection,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedPlansButton(BuildContext context, int count) {
    return _buildNavigationButton(
      context: context,
      title: '내가 담은 AI패키지',
      route: AppRoutes.savedPlans,
    );
  }

  Widget _buildSavedGuidePlansButton(BuildContext context, int count) {
    return _buildNavigationButton(
      context: context,
      title: '내가 담은 가이드 패키지',
      route: AppRoutes.savedGuidePlans,
    );
  }

  Widget _buildNavigationButton({
    required BuildContext context,
    required String title,
    required String route,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grayScale_150,
        borderRadius: AppBorderRadius.small12,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.pushNamed(context, route),
          borderRadius: AppBorderRadius.small12,
          child: Container(
            width: double.infinity,
            padding: AppSpacing.large20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: AppTypography.buttonLabelSmall.copyWith(
                    color: AppColors.grayScale_450,
                  ),
                ),
                Row(
                  children: [
                    const SizedBox(width: 4),
                    SvgPicture.asset(
                      AppIcons.chevronRight,
                      color: AppColors.grayScale_450,
                      width: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
