import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/presentation/provider/schedule_provider.dart';

class ScheduleDayTabs extends ConsumerWidget {
  final int dayCount;

  const ScheduleDayTabs({
    super.key,
    required this.dayCount,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 16),
      child: SizedBox(
        height: 36,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: dayCount,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ChoiceChip(
                label: Text('Day ${index + 1}'),
                selected: ref.watch(selectedDayProvider) == index,
                onSelected: (selected) {
                  if (selected) {
                    ref.read(selectedDayProvider.notifier).state = index;
                  }
                },
                side: BorderSide.none,
                padding: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: AppBorderRadius.large20,
                ),
                backgroundColor: AppColors.grayScale_150,
                selectedColor: AppColors.grayScale_650,
                labelStyle: AppTypography.buttonLabelSmall.copyWith(
                  color: ref.watch(selectedDayProvider) == index
                      ? Colors.white
                      : AppColors.grayScale_450,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
