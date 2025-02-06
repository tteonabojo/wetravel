import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/presentation/pages/guidepackage/widgets/app_bar.dart';
import 'package:wetravel/presentation/pages/guidepackage/widgets/filterd_package_list.dart';
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
      appBar: AppBar(),
      body: Column(
        children: [
          GuideAppBar(),
          GuideFilters(allKeywords: allKeywords),
          FilteredPackageList(allKeywords: allKeywords),
        ],
      ),
    );
  }
}
