import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_icons.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/core/constants/firestore_constants.dart';
import 'package:wetravel/domain/entity/survey_response.dart';
import 'package:wetravel/domain/entity/travel_schedule.dart';
import 'package:wetravel/presentation/provider/schedule_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wetravel/presentation/widgets/buttons/standard_button.dart';
import 'package:wetravel/presentation/pages/schedule/widgets/schedule_header.dart';
import 'package:wetravel/presentation/pages/schedule/widgets/schedule_day_tabs.dart';
import 'package:wetravel/presentation/pages/schedule/widgets/schedule_list.dart';

class AISchedulePage extends ConsumerStatefulWidget {
  const AISchedulePage({super.key});

  @override
  ConsumerState<AISchedulePage> createState() => _AISchedulePageState();
}

class _AISchedulePageState extends ConsumerState<AISchedulePage> {
  bool isEditMode = false;
  final firestoreConstants = FirestoreConstants();

  @override
  Widget build(BuildContext context) {
    final surveyResponse =
        ModalRoute.of(context)!.settings.arguments as SurveyResponse;

    // savedSchedule이 있으면 그것을 사용하고, 없으면 AI로 새로 생성
    final scheduleAsync = surveyResponse.savedSchedule != null
        ? Future.value(surveyResponse.savedSchedule!)
        : ref.watch(scheduleProvider(surveyResponse).future);

    return Scaffold(
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
        actions: [_buildEditButton()],
      ),
      body: SafeArea(
        child: Container(
          color: AppColors.grayScale_050,
          child: FutureBuilder<TravelSchedule>(
            future: scheduleAsync,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary_450,
                  ),
                );
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final schedule = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ScheduleHeader(surveyResponse: surveyResponse),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: AppColors.grayScale_150,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      color: AppColors.grayScale_050,
                      child: Column(
                        children: [
                          ScheduleDayTabs(
                              dayCount:
                                  _getDayCount(surveyResponse.travelDuration)),
                          Expanded(
                            child: ScheduleList(
                              surveyResponse: surveyResponse,
                              isEditMode: isEditMode,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _buildBottomButtons(surveyResponse),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEditButton() {
    return Tooltip(
      message: isEditMode ? '수정 완료' : '일정 수정',
      child: IconButton(
        icon: Icon(isEditMode ? Icons.check : Icons.edit),
        onPressed: () {
          setState(() {
            isEditMode = !isEditMode;
          });
          if (isEditMode) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('일정을 수정할 수 있습니다. 수정이 끝나면 체크 버튼을 눌러주세요.'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildBottomButtons(SurveyResponse surveyResponse) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        color: AppColors.grayScale_050,
        child: Row(
          spacing: 16,
          children: [
            Expanded(
              child: StandardButton.secondary(
                sizeType: ButtonSizeType.normal,
                onPressed: () => Navigator.pop(context),
                text: '뒤로가기',
              ),
            ),
            Expanded(
              child: StandardButton.primary(
                sizeType: ButtonSizeType.normal,
                onPressed: () => _saveSchedule(surveyResponse),
                text: '일정 담기',
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _getDayCount(String duration) {
    final days = int.tryParse(duration.split('박')[0]) ?? 0;
    return days + 1;
  }

  Future<void> _saveSchedule(SurveyResponse surveyResponse) async {
    try {
      // FutureBuilder에서 사용한 것과 동일한 로직으로 일정 가져오기
      TravelSchedule schedule;
      if (surveyResponse.savedSchedule != null) {
        schedule = surveyResponse.savedSchedule!;
      } else {
        schedule = await ref.read(scheduleProvider(surveyResponse).future);
      }

      // 가져온 일정 저장
      await _saveScheduleToFirebase(schedule, surveyResponse);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('일정 저장 실패: $e')),
        );
      }
    }
  }

  Future<void> _saveScheduleToFirebase(
      TravelSchedule schedule, SurveyResponse surveyResponse) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final now = DateTime.now();
      final id = now.millisecondsSinceEpoch.toString();

      final cityName = surveyResponse.selectedCity?.trim() ?? '';
      if (cityName.isEmpty) {
        throw Exception('도시 이름이 없습니다.');
      }

      // 세부 일정 데이터 구조 확인을 위한 로그
      print('Saving schedule days: ${schedule.days.length}');
      print('First day schedules: ${schedule.days.first.schedules.length}');

      final scheduleData = {
        'id': id,
        'title': '$cityName 여행',
        'location': cityName,
        'duration': '${schedule.days.length - 1}박 ${schedule.days.length}일',
        'days': schedule.days
            .map((day) => {
                  'schedules': day.schedules
                      .map((item) => {
                            'time': item.time,
                            'title': item.title,
                            'location': item.location,
                          })
                      .toList(),
                })
            .toList(),
        'imageUrl': await _getImageUrl(cityName),
        'isAIRecommended': true,
        'travelStyle': surveyResponse.travelStyles.isNotEmpty
            ? surveyResponse.travelStyles[0]
            : '관광지',
        'createdAt': now.toIso8601String(),
        // 추가 정보 저장
        'travelPeriod': surveyResponse.travelPeriod,
        'companions': surveyResponse.companions,
        'travelStyles': surveyResponse.travelStyles,
        'accommodationTypes': surveyResponse.accommodationTypes,
        'considerations': surveyResponse.considerations,
      };

      // 저장할 데이터 확인을 위한 로그
      print('Saving schedule data: $scheduleData');

      await FirebaseFirestore.instance
          .collection(firestoreConstants.usersCollection)
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
      print('Error saving schedule: $e'); // 에러 로그 추가
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('저장 실패: $e')),
        );
      }
    }
  }

  Future<String> _getImageUrl(String city) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('city_images')
          .child('$city.jpg');
      try {
        return await storageRef.getDownloadURL();
      } catch (_) {
        return 'https://via.placeholder.com/640x480.jpg?text=$city';
      }
    } catch (e) {
      return 'https://via.placeholder.com/640x480.jpg?text=Error';
    }
  }
}
