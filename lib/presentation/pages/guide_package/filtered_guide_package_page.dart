import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/presentation/pages/guide_package/widgets/filterd_package_list.dart';
import 'package:wetravel/presentation/provider/recommendation_provider.dart';
import 'widgets/filters.dart';

class FilteredGuidePackagePage extends ConsumerWidget {
  const FilteredGuidePackagePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendationState = ref.watch(recommendationStateProvider);

    final allKeywords = [
      ...?recommendationState.selectedCities,
      recommendationState.travelPeriod,
      recommendationState.travelDuration,
      ...?recommendationState.travelStyles,
      ...?recommendationState.companions,
      ...?recommendationState.accommodationTypes,
    ]
        .where((keyword) => keyword != null && keyword.toString().isNotEmpty)
        .map((keyword) => keyword.toString())
        .toList();

    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Container(color: AppColors.grayScale_150, height: 1)),
        backgroundColor: Colors.white,
        title: Text(
          "가이드 맞춤 패키지 추천",
          style:
              AppTypography.headline4.copyWith(color: AppColors.grayScale_950),
        ),
      ),
      body: Column(
        children: [
          GuideFilters(allKeywords: allKeywords),
          FilteredPackageList(allKeywords: allKeywords),
        ],
      ),
    );
  }
}
