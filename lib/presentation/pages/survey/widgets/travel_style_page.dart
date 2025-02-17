import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/presentation/provider/survey/survey_provider.dart';

/// 여행 스타일 페이지
class TravelStylePage extends ConsumerWidget {
  final PageController pageController;

  const TravelStylePage({super.key, required this.pageController});

  void _checkAndNavigate(BuildContext context, WidgetRef ref) {
    if (ref.read(surveyStateProvider.notifier).isCurrentPageComplete()) {
      final state = ref.read(surveyStateProvider);
      print('Travel Style Page - Selected values:');
      print('Companion: ${state.companion}');
      print('Travel Style: ${state.travelStyle}');

      ref.read(surveyStateProvider.notifier).nextPage();
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _buildFilterChip({
    required String label,
    required String selectedValue,
    required String value,
    required WidgetRef ref,
    required BuildContext context,
  }) {
    final isSelected = selectedValue == value;

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
        onSelected: (selected) {
          if (selected) {
            if (value == '혼자' ||
                value == '연인과' ||
                value == '친구와' ||
                value == '가족과') {
              ref.read(surveyStateProvider.notifier).selectCompanion(value);
            } else {
              ref.read(surveyStateProvider.notifier).selectTravelStyle(value);
            }
            _checkAndNavigate(context, ref);
          }
        },
        showCheckmark: false,
        side: const BorderSide(style: BorderStyle.none),
        shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.large20),
        backgroundColor: AppColors.grayScale_050,
        selectedColor: AppColors.grayScale_650,
        labelStyle: AppTypography.buttonLabelSmall.copyWith(
            color: isSelected ? Colors.white : AppColors.grayScale_350));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(surveyStateProvider);

    final companionOptions = ['혼자', '연인과', '친구와', '가족과'];
    final travelStyleOptions = ['액티비티', '휴양', '관광지', '맛집', '문화/예술/역사', '쇼핑'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('어떤 스타일의\n여행을 할 계획인가요?', style: AppTypography.headline2),
        const SizedBox(height: 30),
        Text('누구와',
            style: AppTypography.headline6
                .copyWith(color: AppColors.grayScale_650)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          children: companionOptions.map((option) {
            return _buildFilterChip(
                label: option,
                selectedValue: state.companion ?? '',
                value: option,
                ref: ref,
                context: context);
          }).toList(),
        ),
        const SizedBox(height: 30),
        Text(
          '여행 스타일',
          style: AppTypography.headline6.copyWith(
            color: AppColors.grayScale_650,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          children: travelStyleOptions.map((option) {
            return _buildFilterChip(
                label: option,
                selectedValue: state.travelStyle ?? '',
                value: option,
                ref: ref,
                context: context);
          }).toList(),
        ),
      ],
    );
  }
}
