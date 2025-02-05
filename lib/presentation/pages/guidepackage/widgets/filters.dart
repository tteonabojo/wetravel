import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/presentation/provider/recommendation_provider.dart';

class GuideFilters extends ConsumerWidget {
  const GuideFilters({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendationState = ref.watch(recommendationStateProvider);

    // 선택한 키워드 및 도시 결합
    final allKeywords = [
      ...recommendationState.selectedCities, // 선택한 도시 추가
      recommendationState.travelPeriod,
      recommendationState.travelDuration,
      ...?recommendationState.travelStyles,
      ...?recommendationState.companions,
      ...?recommendationState.accommodationTypes,
    ]
        .where((keyword) => keyword != null && keyword.toString().isNotEmpty)
        .toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: allKeywords
              .map<Widget>(
                (keyword) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Chip(
                    label: Text(keyword.toString()),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
