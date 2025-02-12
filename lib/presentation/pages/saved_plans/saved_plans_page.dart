import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/domain/entity/survey_response.dart';
import 'package:wetravel/presentation/widgets/schedule_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wetravel/domain/entity/schedule.dart';
import 'package:wetravel/presentation/provider/schedule_actions_provider.dart';

class SavedPlansPage extends ConsumerWidget {
  const SavedPlansPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '내가 담은 AI 패키지',
          style: AppTypography.headline4.copyWith(
            color: AppColors.grayScale_950,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection('schedule')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final schedules = snapshot.data?.docs ?? [];

          if (schedules.isEmpty) {
            return const Center(child: Text('저장된 일정이 없습니다'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: schedules.length,
            itemBuilder: (context, index) {
              final scheduleData =
                  schedules[index].data() as Map<String, dynamic>;
              final schedule = Schedule.fromJson(scheduleData);
              return ScheduleCard(
                schedule: schedule,
                onDelete: () {
                  showCupertinoDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                      title: const Text('패키지를 삭제하시겠어요?'),
                      content: const Text('삭제된 패키지는 다시 복구할 수 없어요.'),
                      actions: [
                        CupertinoDialogAction(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('취소'),
                        ),
                        CupertinoDialogAction(
                          onPressed: () async {
                            try {
                              await ref
                                  .read(scheduleActionsProvider)
                                  .deleteSchedule(schedule.id);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('일정이 삭제되었습니다')),
                              );
                            } catch (e) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('삭제 실패: $e')),
                              );
                            }
                          },
                          isDestructiveAction: true,
                          child: const Text('삭제'),
                        ),
                      ],
                    ),
                  );
                },
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/ai-schedule',
                    arguments: SurveyResponse(
                      travelPeriod: schedule.duration,
                      travelDuration: schedule.duration,
                      companions: [schedule.travelStyle],
                      travelStyles: [schedule.travelStyle],
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
      ),
    );
  }
}
