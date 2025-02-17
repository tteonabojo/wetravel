import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/presentation/provider/survey_provider.dart';

class TravelPeriodPage extends ConsumerWidget {
  final PageController pageController;

  const TravelPeriodPage({super.key, required this.pageController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(surveyProvider);
    final notifier = ref.read(surveyProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '여행 기간은\n어떻게 되시나요?',
          style: AppTypography.headline2,
        ),
        const SizedBox(height: 30),
        _buildSectionTitle('여행 시기'),
        _buildChipList(
          state.travelPeriod!,
          ['일주일 이내', '1달 내', '3개월', '일정 계획 없음'],
          (selected) {
            notifier.selectTravelPeriod(selected);
            _checkAndNavigate(context, ref);
          },
        ),
        const SizedBox(height: 30),
        _buildSectionTitle('여행 기간'),
        _buildChipList(
          state.travelDuration!,
          ['당일치기', '1박 2일', '2박 3일', '3박 4일', '4박 5일', '5박 6일'],
          (selected) {
            notifier.selectTravelDuration(selected);
            _checkAndNavigate(context, ref);
          },
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTypography.headline6.copyWith(color: AppColors.grayScale_650),
    );
  }

  Widget _buildChipList(
      String currentValue, List<String> options, Function(String) onSelect) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options
          .map((option) => _buildFilterChip(
              option, currentValue == option, () => onSelect(option)))
          .toList(),
    );
  }

  Widget _buildFilterChip(
      String label, bool isSelected, VoidCallback onSelected) {
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSelected) ...[
            const Icon(Icons.check, size: 16, color: Colors.white),
            const SizedBox(width: 4),
          ],
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      showCheckmark: false,
      side: const BorderSide(style: BorderStyle.none),
      shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.large20),
      backgroundColor: AppColors.grayScale_050,
      selectedColor: AppColors.grayScale_650,
      labelStyle:
          TextStyle(color: isSelected ? Colors.white : AppColors.grayScale_350),
    );
  }

  void _checkAndNavigate(BuildContext context, WidgetRef ref) {
    final state = ref.read(surveyProvider);
    if (state.isCurrentPageComplete()) {
      ref.read(surveyProvider.notifier).nextPage();
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
