import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/domain/entity/survey_response.dart';
import 'package:wetravel/presentation/widgets/schedule_card.dart';
import 'package:wetravel/presentation/provider/user_provider.dart';

class SavedPlansPage extends ConsumerWidget {
  const SavedPlansPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedulesAsync = ref.watch(schedulesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '내가 담은 패키지',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: schedulesAsync.when(
        data: (schedules) {
          if (schedules.isEmpty) {
            return const Center(child: Text('저장된 여행 일정이 없습니다.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: schedules.length,
            itemBuilder: (context, index) {
              final schedule = schedules[index];
              return ScheduleCard(
                schedule: schedule,
                onDelete: () => ref
                    .read(scheduleActionsProvider)
                    .deleteSchedule(schedule.id),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/ai-schedule',
                    arguments: SurveyResponse(
                      travelPeriod: '1개월 이내',
                      travelDuration: '${schedule.duration}일',
                      companions: ['혼자'],
                      travelStyles: ['관광지', '맛집'],
                      accommodationTypes: ['호텔'],
                      considerations: ['위치'],
                      selectedCity: schedule.location,
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          print('Error loading schedules: $error');
          print('Stack trace: $stack');
          return Center(child: Text('Error: $error'));
        },
      ),
    );
  }
}
