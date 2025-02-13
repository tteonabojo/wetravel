import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_icons.dart';
import 'package:wetravel/core/constants/app_shadow.dart';
import 'package:wetravel/core/constants/app_spacing.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/domain/entity/survey_response.dart';
import 'package:wetravel/domain/entity/travel_schedule.dart';
import 'package:wetravel/presentation/provider/schedule_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wetravel/presentation/widgets/buttons/standard_button.dart';

class AISchedulePage extends ConsumerStatefulWidget {
  const AISchedulePage({super.key});

  @override
  ConsumerState<AISchedulePage> createState() => _AISchedulePageState();
}

class _AISchedulePageState extends ConsumerState<AISchedulePage> {
  @override
  Widget build(BuildContext context) {
    final surveyResponse =
        ModalRoute.of(context)!.settings.arguments as SurveyResponse;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          '${surveyResponse.selectedCity}에서 즐기기',
          style:
              AppTypography.headline4.copyWith(color: AppColors.grayScale_950),
        ),
        leading: IconButton(
          icon: SvgPicture.asset(AppIcons.chevronLeft),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: AppSpacing.medium16,
              child: Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      '${surveyResponse.travelDuration} | ${surveyResponse.companions.join(', ')} | ${surveyResponse.accommodationTypes.join(', ')}',
                      style: AppTypography.body2
                          .copyWith(color: AppColors.grayScale_550)),
                  Row(
                    spacing: 4,
                    children: [
                      SvgPicture.asset(AppIcons.mapPin,
                          color: AppColors.grayScale_450, height: 16),
                      Text(surveyResponse.selectedCity ?? '',
                          style: AppTypography.body2
                              .copyWith(color: AppColors.grayScale_550)),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: AppColors.grayScale_150,
            ),
            // 일자별 탭
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                color: AppColors.grayScale_050,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 16),
                      child: SizedBox(
                        height: 36,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              _getDayCount(surveyResponse.travelDuration),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ChoiceChip(
                                label: Text('Day ${index + 1}'),
                                selected:
                                    ref.watch(selectedDayProvider) == index,
                                onSelected: (selected) {
                                  if (selected) {
                                    ref
                                        .read(selectedDayProvider.notifier)
                                        .state = index;
                                  }
                                },
                                side: BorderSide.none,
                                padding: EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                    borderRadius: AppBorderRadius.large20),
                                backgroundColor: AppColors.grayScale_150,
                                selectedColor: AppColors.grayScale_650,
                                labelStyle:
                                    AppTypography.buttonLabelSmall.copyWith(
                                  color: ref.watch(selectedDayProvider) == index
                                      ? Colors.white
                                      : AppColors.grayScale_450,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    /// 🔹 Expanded를 사용하여 남은 공간을 차지하도록 설정
                    Expanded(
                      child: ref.watch(scheduleProvider(surveyResponse)).when(
                            data: (schedule) {
                              final selectedDay =
                                  ref.watch(selectedDayProvider);
                              if (selectedDay >= schedule.days.length)
                                return const SizedBox();

                              final daySchedule = schedule.days[selectedDay];
                              return ListView.builder(
                                itemCount: daySchedule.schedules.length,
                                itemBuilder: (context, index) {
                                  final item = daySchedule.schedules[index];
                                  return _buildScheduleItem(
                                    item.time,
                                    item.title,
                                    item.location,
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
                          ),
                    ),
                  ],
                ),
              ),
            ),

            // 하단 버튼
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                color: AppColors.grayScale_050,
                child: Row(
                  spacing: 16,
                  children: [
                    Expanded(
                        child: StandardButton.secondary(
                            sizeType: ButtonSizeType.normal,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            text: '뒤로가기')),
                    Expanded(
                      child: Consumer(
                        builder: (context, ref, child) {
                          return StandardButton.primary(
                            sizeType: ButtonSizeType.normal,
                            onPressed: () async {
                              try {
                                final scheduleAsync =
                                    ref.read(scheduleProvider(surveyResponse));
                                if (scheduleAsync.hasValue) {
                                  final schedule = scheduleAsync.value!;
                                  await _saveScheduleToFirebase(
                                      schedule, surveyResponse);
                                }
                              } catch (e) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('일정 저장 실패: $e')),
                                  );
                                }
                              }
                            },
                            text: '일정 담기',
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleItem(String time, String title, String location) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppBorderRadius.small12,
          boxShadow: AppShadow.generalShadow),
      margin: EdgeInsets.only(bottom: 12),
      padding: AppSpacing.medium16,
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            time,
            style: AppTypography.body2.copyWith(color: AppColors.grayScale_950),
          ),
          Text(
            title,
            style: AppTypography.headline5
                .copyWith(color: AppColors.grayScale_950),
          ),
          Row(
            spacing: 4,
            children: [
              SvgPicture.asset(AppIcons.mapPin,
                  color: AppColors.grayScale_550, height: 16),
              Text(
                location,
                style: AppTypography.body2
                    .copyWith(color: AppColors.grayScale_650),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int _getDayCount(String duration) {
    // 여행 기간에서 숫자 추출
    final days = int.tryParse(duration.split('박')[0]) ?? 0;
    return days + 1; // N박의 경우 N+1일
  }

  Future<void> _saveScheduleToFirebase(
      TravelSchedule schedule, SurveyResponse surveyResponse) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final now = DateTime.now();
      final id = now.millisecondsSinceEpoch.toString();

      // 도시 이름이 null이거나 빈 문자열인 경우 처리
      final cityName = surveyResponse.selectedCity?.trim() ?? '';
      if (cityName.isEmpty) {
        throw Exception('도시 이름이 없습니다.');
      }

      final scheduleData = {
        'id': id,
        'title': '$cityName 여행', // 도시 이름으로 제목 설정
        'location': cityName, // 도시 이름으로 위치 설정
        'duration': '${schedule.days.length - 1}박 ${schedule.days.length}일',
        'imageUrl': await _getImageUrl(cityName),
        'isAIRecommended': true,
        'travelStyle': surveyResponse.travelStyles.isNotEmpty
            ? surveyResponse.travelStyles[0]
            : '관광',
        'createdAt': now.toIso8601String(), // 생성 시간 추가
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('schedule')
          .doc(id)
          .set(scheduleData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('일정이 저장되었습니다')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('저장 실패: $e')),
        );
      }
    }
  }

  Future<String> _getImageUrl(String city) async {
    try {
      // 이미 firebase_storage에 저장된 도시 이미지가 있다면 그것을 사용
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('city_images')
          .child('$city.jpg');

      try {
        return await storageRef.getDownloadURL();
      } catch (_) {
        // 저장된 이미지가 없는 경우 기본 이미지 URL 반환
        return 'https://via.placeholder.com/640x480.jpg?text=$city';
      }
    } catch (e) {
      return 'https://via.placeholder.com/640x480.jpg?text=Error';
    }
  }
}
