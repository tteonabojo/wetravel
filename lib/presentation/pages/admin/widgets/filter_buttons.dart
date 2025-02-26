import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/presentation/pages/admin/admin_page_view_model.dart';
import 'package:wetravel/presentation/widgets/buttons/chip_button.dart';

class FilterButtons extends ConsumerWidget {
  const FilterButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(adminPageViewModelProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: ['전체 패키지', '공개 패키지', '비공개 패키지'].map((filter) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: ChipButton(
            disabledType: DisabledType.disabled150,
            text: filter,
            isSelected: viewModel.selectedFilter == filter,
            onPressed: () {
              viewModel.setSelectedFilter(filter);
            },
          ),
        );
      }).toList(),
    );
  }
}
