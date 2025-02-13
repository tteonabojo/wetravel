import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/app_colors.dart';
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 20),
              Text(
                '${surveyResponse.selectedCity}에서 즐기기',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${surveyResponse.travelDuration} | ${surveyResponse.companions.join(', ')} | ${surveyResponse.accommodationTypes.join(', ')}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              Row(
                children: [
                  Icon(Icons.location_on_outlined,
                      color: Colors.grey[600], size: 20),
                  const SizedBox(width: 4),
                  Text(
                    surveyResponse.selectedCity ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // 일자별 탭
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _getDayCount(surveyResponse.travelDuration),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text('Day ${index + 1}'),
                        selected: ref.watch(selectedDayProvider) == index,
                        onSelected: (selected) {
                          if (selected) {
                            ref.read(selectedDayProvider.notifier).state =
                                index;
                          }
                        },
                        backgroundColor: Colors.grey[200],
                        selectedColor: Colors.grey[600],
                        labelStyle: TextStyle(
                          color: ref.watch(selectedDayProvider) == index
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              // 일정 목록
              Expanded(
                child: ref.watch(scheduleProvider(surveyResponse)).when(
                      data: (schedule) {
                        final selectedDay = ref.watch(selectedDayProvider);
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
              // 하단 버튼
              Row(
                children: [
                  Expanded(
                      child: StandardButton.secondary(
                          sizeType: ButtonSizeType.medium,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          text: '뒤로가기')),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, child) {
                        return StandardButton.primary(
                          sizeType: ButtonSizeType.medium,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleItem(String time, String title, String location) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              time,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.location_on_outlined,
                    color: Colors.grey[600], size: 16),
                const SizedBox(width: 4),
                Text(
                  location,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
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
