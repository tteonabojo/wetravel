import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/presentation/provider/survey/survey_provider.dart';

/// 여행 기간 페이지
class TravelPeriodPage extends ConsumerWidget {
  final PageController pageController;

  const TravelPeriodPage({super.key, required this.pageController});

  void _checkAndNavigate(BuildContext context, WidgetRef ref) {
    final state = ref.read(surveyStateProvider);
    if (state.travelPeriod != null &&
        state.travelDuration != null &&
        state.travelPeriod != state.travelDuration) {
      ref.read(surveyStateProvider.notifier).nextPage();
      pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(surveyStateProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('여행 기간은\n어떻게 되시나요?', style: AppTypography.headline2),
        const SizedBox(height: 30),
        _buildSectionTitle('여행 시기'),
        SizedBox(height: 12),
        _buildFilterChips(ref, context, state.travelPeriod,
            ['일주일 이내', '1달 내', '3개월', '일정 계획 없음'], true),
        const SizedBox(height: 30),
        _buildSectionTitle('여행 기간'),
        SizedBox(height: 12),
        _buildFilterChips(ref, context, state.travelDuration,
            ['당일치기', '1박 2일', '2박 3일', '3박 4일', '4박 5일', '5박 6일'], false),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title,
        style:
            AppTypography.headline6.copyWith(color: AppColors.grayScale_650));
  }

  Widget _buildFilterChips(WidgetRef ref, BuildContext context,
      String? selectedValue, List<String> options, bool isPeriod) {
    return Wrap(
      spacing: 8,
      children: options
          .map((option) =>
              _buildFilterChip(ref, context, selectedValue, option, isPeriod))
          .toList(),
    );
  }

  Widget _buildFilterChip(WidgetRef ref, BuildContext context,
      String? selectedValue, String option, bool isPeriod) {
    return FilterChip(
        padding: EdgeInsets.all(10),
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selectedValue == option)
              const Icon(Icons.check, size: 16, color: Colors.white),
            if (selectedValue == option) const SizedBox(width: 4),
            Text(option),
          ],
        ),
        selected: selectedValue == option,
        onSelected: (selected) {
          if (selected) {
            final notifier = ref.read(surveyStateProvider.notifier);
            isPeriod
                ? notifier.selectTravelPeriod(option)
                : notifier.selectTravelDuration(option);
            _checkAndNavigate(context, ref);
          }
        },
        showCheckmark: false,
        side: const BorderSide(style: BorderStyle.none),
        shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.large20),
        backgroundColor: AppColors.grayScale_050,
        selectedColor: AppColors.grayScale_650,
        labelStyle: AppTypography.buttonLabelSmall.copyWith(
            color: selectedValue == option
                ? Colors.white
                : AppColors.grayScale_350));
  }
}
