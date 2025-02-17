import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/presentation/pages/guide_package/widgets/filterd_package_list.dart';
import 'package:wetravel/presentation/pages/guide_package/widgets/filters.dart';
import 'package:wetravel/presentation/provider/survey/survey_provider.dart';

/// 선택한 키워드를 모아서 보여주는 페이지
class FilteredGuidePackagePage extends ConsumerWidget {
  const FilteredGuidePackagePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(surveyStateProvider);

    final selectedKeywords = [
      if (state.travelPeriod != null) {'value': state.travelPeriod},
      if (state.travelDuration != null) {'value': state.travelDuration},
      if (state.companion != null) {'value': state.companion},
      if (state.travelStyle != null) {'value': state.travelStyle},
      if (state.accommodationType != null) {'value': state.accommodationType},
      if (state.consideration != null) {'value': state.consideration},
      if (state.selectedCities.isNotEmpty)
        {'value': state.selectedCities.join(', ')},
    ].map((keyword) => keyword['value']).whereType<String>().toList();

    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Container(color: AppColors.grayScale_150, height: 1)),
        backgroundColor: Colors.white,
        title: Text('가이드 맞춤 패키지 추천', style: AppTypography.headline4),
      ),
      body: selectedKeywords.isNotEmpty
          ? Column(
              children: [
                GuideFilters(
                  selectedKeywords: selectedKeywords,
                ),
                FilteredPackageList(selectedKeywords: selectedKeywords),
              ],
            )
          : const Center(
              child: Text(
                '선택된 키워드가 없습니다.',
                style: AppTypography.body2,
              ),
            ),
    );
  }
}
