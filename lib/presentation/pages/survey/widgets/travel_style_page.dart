import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/presentation/provider/survey_provider.dart';

/// 여행 스타일 페이지
class TravelStylePage extends ConsumerWidget {
  final PageController pageController;

  const TravelStylePage({super.key, required this.pageController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(surveyProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '어떤 스타일의\n여행을 할 계획인가요?',
          style: AppTypography.headline2,
        ),
        const SizedBox(height: 30),
        _buildSectionTitle('누구와'),
        _buildFilterChipGroup(
          options: ['혼자', '연인과', '친구와', '가족과'],
          selectedValue: state.companion!,
          onSelected: (value) {
            ref.read(surveyProvider.notifier).selectCompanion(value);
            _checkAndNavigate(context, ref);
          },
        ),
        const SizedBox(height: 30),
        _buildSectionTitle('여행 스타일'),
        _buildFilterChipGroup(
          options: ['액티비티', '휴양', '관광지', '맛집', '문화/예술/역사', '쇼핑'],
          selectedValue: state.travelStyle!,
          onSelected: (value) {
            ref.read(surveyProvider.notifier).selectTravelStyle(value);
            _checkAndNavigate(context, ref);
          },
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTypography.headline6.copyWith(
        color: AppColors.grayScale_650,
      ),
    );
  }

  Widget _buildFilterChipGroup({
    required List<String> options,
    required String selectedValue,
    required Function(String) onSelected,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options
          .map((option) => _buildFilterChip(option, selectedValue, onSelected))
          .toList(),
    );
  }

  Widget _buildFilterChip(
      String label, String selectedValue, Function(String) onSelected) {
    final isSelected = label == selectedValue;
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSelected)
            const Icon(Icons.check, size: 16, color: Colors.white),
          if (isSelected) const SizedBox(width: 4),
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) => onSelected(label),
      showCheckmark: false,
      side: const BorderSide(style: BorderStyle.none),
      shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.large20),
      backgroundColor: AppColors.grayScale_050,
      selectedColor: AppColors.grayScale_650,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.grayScale_350,
      ),
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
