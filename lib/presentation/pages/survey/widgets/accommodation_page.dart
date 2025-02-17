import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/presentation/provider/survey_provider.dart';

/// 숙소 스타일 페이지
class AccommodationPage extends ConsumerWidget {
  final PageController pageController;

  const AccommodationPage({super.key, required this.pageController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(surveyProvider);
    final surveyNotifier = ref.read(surveyProvider.notifier);

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
        _buildSectionTitle('숙소 스타일'),
        _buildFilterChipList(
          items: accommodationTypes,
          selectedItem: state.accommodationType!,
          onSelected: (type) {
            surveyNotifier.selectAccommodationType(type);
            _checkAndNavigate(context, ref);
          },
        ),
        const SizedBox(height: 30),
        _buildSectionTitle('고려사항'),
        _buildFilterChipList(
          items: considerations,
          selectedItem: state.consideration!,
          onSelected: (consideration) {
            surveyNotifier.selectConsideration(consideration);
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

  Widget _buildFilterChipList({
    required List<String> items,
    required String selectedItem,
    required Function(String) onSelected,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items
          .map((item) => _buildFilterChip(item, selectedItem, onSelected))
          .toList(),
    );
  }

  Widget _buildFilterChip(
      String label, String selectedItem, Function(String) onSelected) {
    final isSelected = label == selectedItem;
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
      onSelected: (selected) => selected ? onSelected(label) : null,
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
      if (state.currentPage == 2) {
        final surveyResponse = state.toSurveyResponse();
        Navigator.pushNamed(context, '/plan-selection',
            arguments: surveyResponse);
      } else {
        ref.read(surveyProvider.notifier).nextPage();
        pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }
}
