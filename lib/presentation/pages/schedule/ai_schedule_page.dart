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
  TravelSchedule? editedSchedule;
  final firestoreConstants = FirestoreConstants();

  /// 파이어베이스에서 일정을 가져오는 함수
  Future<TravelSchedule> _loadSchedule(SurveyResponse surveyResponse) {
    return FirebaseFirestore.instance
        .collection(firestoreConstants.usersCollection)
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('schedule')
        .doc(surveyResponse.savedSchedule?.id)
        .get()
        .then<TravelSchedule>((doc) {
      if (doc.exists) {
        return TravelSchedule.fromFirestore(doc.data()!);
      }
      return ref.read(scheduleProvider(surveyResponse).future);
    });
  }

  /// 일정 수정 버튼 위젯
  Widget _buildEditButton() {
    return Tooltip(
      message: isEditMode ? '수정 완료' : '일정 수정',
      child: IconButton(
        icon: Icon(isEditMode ? Icons.check : Icons.edit),
        onPressed: () async {
          if (isEditMode && editedSchedule != null) {
            // 수정 완료 시 저장
            final surveyResponse =
                ModalRoute.of(context)!.settings.arguments as SurveyResponse;
            await _saveScheduleToFirebase(editedSchedule!, surveyResponse);

            // 저장 완료 메시지 표시
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('일정이 저장되었습니다')),
              );
            }
          }

          setState(() {
            isEditMode = !isEditMode;
          });

          // 수정 모드 진입 시 안내 메시지
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

  /// 일정 저장 함수
  Future<void> _saveSchedule(SurveyResponse surveyResponse) async {
    try {
      final schedule = editedSchedule ??
          await ref.read(scheduleProvider(surveyResponse).future);
      if (schedule != null) {
        await _saveScheduleToFirebase(schedule, surveyResponse);

        // 저장 성공 시 저장된 일정 목록 페이지로 이동
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/saved-plans',
            (route) => route.settings.name == '/',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('일정 저장 실패: $e')),
        );
      }
    }
  }

  /// 파이어베이스에 일정 저장하는 함수
  Future<void> _saveScheduleToFirebase(
      TravelSchedule schedule, SurveyResponse surveyResponse) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // 일정 ID 생성 또는 기존 ID 사용
      final now = DateTime.now();
      final id = schedule.id.isEmpty
          ? now.millisecondsSinceEpoch.toString()
          : schedule.id;

      // 도시 이름 검증
      final cityName = surveyResponse.selectedCity?.trim() ?? '';
      if (cityName.isEmpty) {
        throw Exception('도시 이름이 없습니다.');
      }

      // 저장할 데이터 준비
      final scheduleData = await _prepareScheduleData(
        schedule,
        surveyResponse,
        id,
        cityName,
        now,
      );

      // 파이어베이스에 저장
      await FirebaseFirestore.instance
          .collection(firestoreConstants.usersCollection)
          .doc(user.uid)
          .collection('schedule')
          .doc(id)
          .set(scheduleData, SetOptions(merge: true));

      // 저장된 일정으로 상태 업데이트
      final updatedSchedule = TravelSchedule(
        id: id,
        destination: schedule.destination,
        days: schedule.days,
      );

      setState(() {
        editedSchedule = updatedSchedule;
      });
    } catch (e) {
      rethrow; // 상위 에러 핸들러에서 처리하도록 전파
    }
  }

  /// 저장할 일정 데이터 준비
  Future<Map<String, dynamic>> _prepareScheduleData(
    TravelSchedule schedule,
    SurveyResponse surveyResponse,
    String id,
    String cityName,
    DateTime now,
  ) async {
    return {
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
      'travelPeriod': surveyResponse.travelPeriod,
      'companions': surveyResponse.companions,
      'travelStyles': surveyResponse.travelStyles,
      'accommodationTypes': surveyResponse.accommodationTypes,
      'considerations': surveyResponse.considerations,
    };
  }

  @override
  Widget build(BuildContext context) {
    final surveyResponse =
        ModalRoute.of(context)!.settings.arguments as SurveyResponse;

    // 파이어베이스에서 실시간으로 일정을 가져오도록 수정
    final Future<TravelSchedule> scheduleAsync = _loadSchedule(surveyResponse);

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

              if (snapshot.hasData) {
                final currentSchedule = editedSchedule ?? snapshot.data!;
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
                        color: AppColors.grayScale_050,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                              child: ScheduleDayTabs(
                                  dayCount: _getDayCount(
                                      surveyResponse.travelDuration)),
                            ),
                            Expanded(
                              child: ScheduleList(
                                surveyResponse: surveyResponse,
                                isEditMode: isEditMode,
                                schedule: currentSchedule,
                                onScheduleUpdate: (updatedSchedule) {
                                  setState(() {
                                    editedSchedule = updatedSchedule;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _buildBottomButtons(surveyResponse),
                  ],
                );
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
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
