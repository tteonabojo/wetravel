import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_spacing.dart';
import 'package:wetravel/core/constants/app_typography.dart';

class GuideFilters extends ConsumerWidget {
  final List<String> allKeywords;

  const GuideFilters({super.key, required this.allKeywords});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: allKeywords
                  .map<Widget>(
                    (keyword) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Chip(
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: AppBorderRadius.small8),
                        side: BorderSide.none,
                        backgroundColor: Colors.black45,
                        label: Text(
                          keyword,
                          style: AppTypography.buttonLabelSmall
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
