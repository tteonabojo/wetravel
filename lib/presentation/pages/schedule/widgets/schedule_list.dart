import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/domain/entity/survey_response.dart';
import 'package:wetravel/presentation/provider/schedule_provider.dart';
import 'package:wetravel/presentation/pages/schedule/widgets/schedule_item.dart';
import 'package:wetravel/presentation/pages/schedule/widgets/time_picker_bottom_sheet.dart';

class ScheduleList extends ConsumerWidget {
  final SurveyResponse surveyResponse;
  final bool isEditMode;

  const ScheduleList({
    super.key,
    required this.surveyResponse,
    required this.isEditMode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(scheduleProvider(surveyResponse)).when(
          data: (schedule) {
            final selectedDay = ref.watch(selectedDayProvider);
            if (selectedDay >= schedule.days.length) {
              return const SizedBox();
            }

            final daySchedule = schedule.days[selectedDay];
            return isEditMode
                ? ReorderableListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: daySchedule.schedules.length,
                    onReorder: (oldIndex, newIndex) {
                      // TODO: 순서 변경 로직 구현
                    },
                    itemBuilder: (context, index) {
                      final item = daySchedule.schedules[index];
                      return ScheduleItem(
                        key: ValueKey('${item.time}-${item.title}'),
                        itemKey: ValueKey('${item.time}-${item.title}'),
                        time: item.time,
                        title: item.title,
                        location: item.location,
                        isEditMode: isEditMode,
                        onTap: () => _showEditDialog(
                          context,
                          item.time,
                          item.title,
                          item.location,
                          (time, title, location) {
                            // TODO: 수정 로직 구현
                          },
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    itemCount: daySchedule.schedules.length,
                    itemBuilder: (context, index) {
                      final item = daySchedule.schedules[index];
                      return ScheduleItem(
                        key: ValueKey('${item.time}-${item.title}'),
                        time: item.time,
                        title: item.title,
                        location: item.location,
                        isEditMode: isEditMode,
                        itemKey: ValueKey('${item.time}-${item.title}'),
                      );
                    },
                  );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary_450,
            ),
          ),
          error: (error, stack) => Center(
            child: Text('Error: $error'),
          ),
        );
  }

  void _showEditDialog(
    BuildContext context,
    String time,
    String title,
    String location,
    Function(String, String, String) onSave,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TimePickerBottomSheet(
        initialTime: time,
        initialTitle: title,
        initialLocation: location,
        onSave: onSave,
      ),
    );
  }
}
