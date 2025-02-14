import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dayCount,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: ref.watch(selectedDayProvider) == index
                    ? AppColors.grayScale_750
                    : AppColors.grayScale_150,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () {
                    ref.read(selectedDayProvider.notifier).state = index;
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Text(
                      'Day ${index + 1}',
                      style: AppTypography.body3.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: ref.watch(selectedDayProvider) == index
                            ? Colors.white
                            : AppColors.grayScale_450,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
