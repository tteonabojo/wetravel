import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/core/constants/firestore_constants.dart';
import 'package:wetravel/domain/entity/survey_response.dart';
import 'package:wetravel/presentation/provider/schedule_provider.dart';
import 'package:wetravel/presentation/widgets/schedule_card.dart';
import 'package:wetravel/domain/entity/schedule.dart';
import 'package:wetravel/presentation/provider/schedule_actions_provider.dart';

class SavedPlansPage extends ConsumerWidget {
  SavedPlansPage({super.key});
  final firestoreConstants = FirestoreConstants();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packagesAsyncValue = ref.watch(scrapPackagesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '내가 담은 AI 패키지',
          style: AppTypography.headline4.copyWith(
            color: AppColors.grayScale_950,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(firestoreConstants.usersCollection)
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection(firestoreConstants.schedulesCollection)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: AppColors.primary_450,
            ));
          }

          final schedules = snapshot.data?.docs ?? [];

          if (schedules.isEmpty) {
            return const Center(child: Text('저장된 일정이 없습니다'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: packages.length,
            itemBuilder: (context, index) {
              final scheduleData = packages[index];
              return _buildScheduleCard(context, ref, scheduleData);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildScheduleCard(
      BuildContext context, WidgetRef ref, Map<String, dynamic> data) {
    final schedule = Schedule(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      location: data['location'] ?? '',
      duration: data['duration'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      day: 1, // 기본값 설정
      isAIRecommended: data['isAIRecommended'] ?? true,
      travelStyle: data['travelStyle'] ?? '관광',
      content: '', // 기본값 설정
      time: data['createdAt'] ?? '',
      packageId: '', // 기본값 설정
      order: 0, // 기본값 설정
    );

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
  }
}
