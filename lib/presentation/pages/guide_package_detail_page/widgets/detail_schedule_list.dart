import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_shadow.dart';
import 'package:wetravel/core/constants/app_spacing.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/presentation/pages/guide/package_register_page/widgets/widgets/bottom_sheet/list_bottom_sheet.dart';
import 'package:wetravel/presentation/pages/guide_package_detail_page/widgets/detail_schedule_list_view_model.dart';
import 'package:wetravel/presentation/pages/guide_package_detail_page/widgets/schedule_detail_item.dart';

class DetailScheduleList extends ConsumerWidget {
  const DetailScheduleList({
    required this.schedules,
    required this.totalScheduleCount,
    required this.dayIndex,
    required this.onSave,
    required this.onDelete,
    required this.key,
  });

  final List<Map<String, String>> schedules;
  final int totalScheduleCount;
  final int dayIndex;
  final Function(String time, String title, String location, String content,
      int scheduleIndex) onSave;
  final Function(int dayIndex, int scheduleIndex) onDelete;
  final Key key;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleViewModel = ref.watch(detailScheduleViewModelProvider);

    return Column(
      key: key,
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
          child: ScheduleDetailItem(
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
                    time: entry.value['time'] ?? '오전 9:00',
                    onSave: (
                      title,
                      location,
                      time,
                      description,
                    ) {
                      scheduleViewModel.updateSchedule(
                        time,
                        title,
                        location,
                        description,
                      );
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
            key: key,
          ),
        );
      }).toList(),
    );
  }
}
