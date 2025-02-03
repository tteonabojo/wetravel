import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_shadow.dart';
import 'package:wetravel/core/constants/app_spacing.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/presentation/pages/guide/package_register_page/widgets/schedule_list_view_model.dart';
import 'package:wetravel/presentation/pages/guide/package_register_page/widgets/widgets/bottom_sheet/list_bottom_sheet.dart';
import 'package:wetravel/presentation/pages/guide/package_register_page/widgets/widgets/schedule_item.dart';

class ScheduleList extends ConsumerWidget {
  const ScheduleList({
    super.key,
    required this.schedules,
    required this.totalScheduleCount,
    required this.dayIndex,
    required this.onSave,
    required this.onDelete,
  });

  final List<Map<String, String>> schedules;
  final int totalScheduleCount;
  final int dayIndex;
  final Function(String time, String title, String location, String content,
      int scheduleIndex) onSave;
  final Function(int dayIndex, int scheduleIndex) onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleViewModel = ref.watch(scheduleViewModelProvider);

    return Column(
      spacing: 16,
      children: schedules.asMap().entries.map((entry) {
        return AnimatedContainer(
          duration: Durations.medium2,
          curve: Curves.easeInOut,
          padding: AppSpacing.medium16,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: AppBorderRadius.small12,
            ),
            shadows: AppShadow.generalShadow,
          ),
          child: ScheduleItem(
            totalScheduleItemCount: totalScheduleCount,
            time: entry.value['time'] ?? '오전 9:00',
            title: entry.value['title'] ?? '제목',
            location: entry.value['location'] ?? '위치',
            content: entry.value['content'] ?? '설명',
            bodyStyle:
                AppTypography.body2.copyWith(color: AppColors.grayScale_650),
            headlineStyle: AppTypography.headline5
                .copyWith(color: AppColors.grayScale_950),
            onDelete: () => onDelete(dayIndex, entry.key),
            onEdit: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                builder: (context) {
                  return ListBottomSheet(
                    title: entry.value['title'] ?? '제목',
                    location: entry.value['location'] ?? '위치',
                    content: entry.value['content'] ?? '설명',
                    onSave: (
                      title,
                      location,
                      time,
                      description,
                    ) {
                      // 일정 수정 시 기존 일정의 index를 onSave로 전달
                      scheduleViewModel.updateSchedule(
                        time,
                        title,
                        location,
                        description,
                      );
                      // 수정된 일정 저장
                      onSave(
                        time,
                        title,
                        location,
                        description,
                        entry.key,
                      );
                    },
                  );
                },
              );
            },
          ),
        );
      }).toList(),
    );
  }
}
