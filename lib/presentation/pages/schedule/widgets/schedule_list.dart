import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/domain/entity/survey_response.dart';
import 'package:wetravel/domain/entity/travel_schedule.dart';
import 'package:wetravel/presentation/pages/schedule/widgets/schedule_item.dart';
import 'package:wetravel/presentation/provider/schedule_provider.dart';
import 'package:wetravel/presentation/pages/schedule/widgets/time_picker_bottom_sheet.dart';

class ScheduleList extends ConsumerWidget {
  final SurveyResponse surveyResponse;
  final bool isEditMode;
  final TravelSchedule schedule;
  final Function(TravelSchedule)? onScheduleUpdate;

  const ScheduleList({
    super.key,
    required this.surveyResponse,
    required this.isEditMode,
    required this.schedule,
    this.onScheduleUpdate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDay = ref.watch(selectedDayProvider);
    if (selectedDay >= schedule.days.length) {
      return const SizedBox();
    }

    final daySchedule = schedule.days[selectedDay];
    return isEditMode
        ? ReorderableListView.builder(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
            itemCount: daySchedule.schedules.length,
            onReorder: (oldIndex, newIndex) {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final updatedSchedule = schedule.copyWith(
                days: List.from(schedule.days)
                  ..[selectedDay] = schedule.days[selectedDay].copyWith(
                    schedules: List.from(daySchedule.schedules)
                      ..insert(newIndex, daySchedule.schedules[oldIndex])
                      ..removeAt(oldIndex > newIndex ? oldIndex + 1 : oldIndex),
                  ),
              );
              onScheduleUpdate?.call(updatedSchedule);
            },
            itemBuilder: (context, index) {
              final item = daySchedule.schedules[index];
              return ScheduleItemWidget(
                key: ValueKey(item.hashCode),
                itemKey: ValueKey(item.hashCode),
                time: item.time,
                title: item.title,
                location: item.location,
                isEditMode: isEditMode,
                onTap: () => _showEditDialog(
                  context,
                  item.time,
                  item.title,
                  item.location,
                  (newTime, newTitle, newLocation) {
                    final updatedSchedule = schedule.copyWith(
                      days: List.from(schedule.days)
                        ..[selectedDay] = schedule.days[selectedDay].copyWith(
                          schedules: List.from(daySchedule.schedules)
                            ..[index] = item.copyWith(
                              time: newTime,
                              title: newTitle,
                              location: newLocation,
                            ),
                        ),
                    );
                    onScheduleUpdate?.call(updatedSchedule);
                  },
                ),
              );
            },
          )
        : ListView.builder(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
            itemCount: daySchedule.schedules.length,
            itemBuilder: (context, index) {
              final item = daySchedule.schedules[index];
              return ScheduleItemWidget(
                key: ValueKey('${item.time}-${item.title}'),
                itemKey: ValueKey('${item.time}-${item.title}'),
                time: item.time,
                title: item.title,
                location: item.location,
                isEditMode: isEditMode,
              );
            },
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
