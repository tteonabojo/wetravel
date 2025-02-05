import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/presentation/provider/recommendation_provider.dart';

class GuideFilters extends ConsumerWidget {
  const GuideFilters({super.key});

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
