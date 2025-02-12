import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_shadow.dart';
import 'package:wetravel/core/constants/app_spacing.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/data/dto/schedule_dto.dart';
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

  final List<ScheduleDto> schedules;
  final int totalScheduleCount;
  final int dayIndex;
  final Function(String time, String title, String location, String content,
      int scheduleIndex) onSave;
  final Function(int dayIndex, int scheduleIndex) onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleViewModel = ref.watch(scheduleViewModelProvider);

    return Column(
      children: schedules.asMap().entries.map((entry) {
        final schedule = entry.value;

        return Column(
          children: [
            AnimatedContainer(
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
                time: schedule.time.isEmpty ? '오전 9:00' : schedule.time,
                title: schedule.title.isEmpty ? '제목' : schedule.title,
                location: schedule.location.isEmpty ? '위치' : schedule.location,
                content: schedule.content.isEmpty ? '설명' : schedule.content,
                bodyStyle: AppTypography.body2
                    .copyWith(color: AppColors.grayScale_650),
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
                        title: schedule.title,
                        location: schedule.location,
                        content: schedule.content,
                        time: schedule.time,
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
              ),
            ),
            SizedBox(height: 12)
          ],
        );
      }).toList(),
    );
  }
}
