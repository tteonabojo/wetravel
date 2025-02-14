import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/domain/entity/survey_response.dart';
import 'package:wetravel/domain/entity/travel_schedule.dart';
import 'package:wetravel/presentation/provider/schedule_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wetravel/presentation/widgets/buttons/standard_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:wetravel/presentation/pages/schedule/widgets/schedule_header.dart';
import 'package:wetravel/presentation/pages/schedule/widgets/schedule_day_tabs.dart';
import 'package:wetravel/presentation/pages/schedule/widgets/schedule_list.dart';

class AISchedulePage extends ConsumerStatefulWidget {
  const AISchedulePage({super.key});

  @override
  ConsumerState<AISchedulePage> createState() => _AISchedulePageState();
}

class _AISchedulePageState extends ConsumerState<AISchedulePage> {
  bool isEditMode = false; // 수정 모드 상태 추가

  @override
  Widget build(BuildContext context) {
    final surveyResponse =
        ModalRoute.of(context)!.settings.arguments as SurveyResponse;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(surveyResponse),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScheduleHeader(surveyResponse: surveyResponse),
              const SizedBox(height: 20),
              ScheduleDayTabs(
                dayCount: _getDayCount(surveyResponse.travelDuration),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ScheduleList(
                  surveyResponse: surveyResponse,
                  isEditMode: isEditMode,
                ),
              ),
              _buildBottomButtons(context, surveyResponse),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(SurveyResponse surveyResponse) {
    return AppBar(
      title: Text(
        '${surveyResponse.selectedCity}와 떠나는 도쿄 여행',
        style: AppTypography.headline4.copyWith(
          color: AppColors.grayScale_950,
        ),
      ),
      actions: [
        Tooltip(
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
        ),
      ],
    );
  }

  Widget _buildBottomButtons(
      BuildContext context, SurveyResponse surveyResponse) {
    return Row(
      children: [
        Expanded(
          child: StandardButton.secondary(
            sizeType: ButtonSizeType.medium,
            onPressed: () {
              Navigator.pop(context);
            },
            text: '뒤로가기',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StandardButton.primary(
            sizeType: ButtonSizeType.medium,
            onPressed: () async {
              try {
                final scheduleAsync =
                    ref.read(scheduleProvider(surveyResponse));
                if (scheduleAsync.hasValue) {
                  final schedule = scheduleAsync.value!;
                  await _saveScheduleToFirebase(schedule, surveyResponse);
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
          ),
        ),
      ],
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
      final collectionPath = kDebugMode ? 'users_test' : 'users';

      final cityName = surveyResponse.selectedCity?.trim() ?? '';
      if (cityName.isEmpty) {
        throw Exception('도시 이름이 없습니다.');
      }

      final scheduleData = {
        'id': id,
        'title': '$cityName 여행',
        'location': cityName,
        'duration': '${schedule.days.length - 1}박 ${schedule.days.length}일',
        'imageUrl': await _getImageUrl(cityName),
        'isAIRecommended': true,
        'travelStyle': surveyResponse.travelStyles.isNotEmpty
            ? surveyResponse.travelStyles[0]
            : '관광지',
        'createdAt': now.toIso8601String(),
      };

      await FirebaseFirestore.instance
          .collection(collectionPath)
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
