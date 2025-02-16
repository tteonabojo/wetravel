import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/domain/entity/survey_response.dart';
import 'package:wetravel/presentation/provider/survey/survey_provider.dart';

/// 숙소 스타일 페이지
class AccommodationPage extends ConsumerWidget {
  final PageController pageController;

  const AccommodationPage({super.key, required this.pageController});

  void _checkAndNavigate(BuildContext context, WidgetRef ref) {
    if (ref.read(surveyStateProvider.notifier).isCurrentPageComplete()) {
      final state = ref.read(surveyStateProvider);
      print('Creating SurveyResponse from AccommodationPage:');
      print('Travel Period: ${state.travelPeriod}');
      print('Travel Duration: ${state.travelDuration}');
      print('Companion: ${state.companion}');
      print('Travel Style: ${state.travelStyle}');
      print('Accommodation Type: ${state.accommodationType}');
      print('Consideration: ${state.consideration}');
      print('Selected City: ${state.selectedCities}');

      if (state.currentPage == 2) {
        final surveyResponse = SurveyResponse(
          travelPeriod: state.travelPeriod ?? '',
          travelDuration: state.travelDuration ?? '',
          companions: state.companion != null ? [state.companion!] : [],
          travelStyles: state.travelStyle != null ? [state.travelStyle!] : [],
          accommodationTypes:
              state.accommodationType != null ? [state.accommodationType!] : [],
          considerations:
              state.consideration != null ? [state.consideration!] : [],
          selectedCity: state.selectedCities.isNotEmpty
              ? state.selectedCities.first
              : null,
        );

        Navigator.pushNamed(
          context,
          '/plan-selection',
          arguments: surveyResponse,
        );
      }
    }
  }

  List<Widget> _buildFilterChips({
    required List<String> options,
    required String? selectedValue,
    required Function(String) onSelected,
    required WidgetRef ref,
  }) {
    return options.map((value) {
      return FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selectedValue == value) ...[
              const Icon(Icons.check, size: 16, color: Colors.white),
              const SizedBox(width: 4),
            ],
            Text(value),
          ],
        ),
        selected: selectedValue == value,
        onSelected: (selected) {
          if (selected) {
            onSelected(value);
            _checkAndNavigate(ref.context, ref);
          }
        },
        showCheckmark: false,
        side: const BorderSide(style: BorderStyle.none),
        shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.large20),
        backgroundColor: AppColors.grayScale_050,
        selectedColor: AppColors.grayScale_650,
        labelStyle: TextStyle(
          color:
              selectedValue == value ? Colors.white : AppColors.grayScale_350,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(surveyStateProvider);

    final accommodationTypes = ['호텔', '게스트 하우스', '에어비앤비', '캠핑'];
    final considerations = ['가성비', '시설', '위치', '청결', '기온', '시차', '없음'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '숙소 스타일과\n고려해야할 사항을 알려주세요',
          style: AppTypography.headline2,
        ),
        const SizedBox(height: 30),
        Text(
          '숙소 스타일',
          style: AppTypography.headline6.copyWith(
            color: AppColors.grayScale_650,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _buildFilterChips(
            options: accommodationTypes,
            selectedValue: state.accommodationType ?? '',
            onSelected: (value) => ref
                .read(surveyStateProvider.notifier)
                .selectAccommodationType(value),
            ref: ref,
          ),
        ),
        const SizedBox(height: 30),
        Text(
          '고려사항',
          style: AppTypography.headline6.copyWith(
            color: AppColors.grayScale_650,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _buildFilterChips(
            options: considerations,
            selectedValue: state.consideration ?? '',
            onSelected: (value) => ref
                .read(surveyStateProvider.notifier)
                .selectConsideration(value),
            ref: ref,
          ),
        ),
      ],
    );
  }
}
