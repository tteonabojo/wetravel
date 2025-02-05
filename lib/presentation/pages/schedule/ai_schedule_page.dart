import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:wetravel/domain/entity/schedule.dart';
import 'package:wetravel/domain/entity/survey_response.dart';
import 'package:wetravel/presentation/provider/schedule_provider.dart';
import 'package:wetravel/presentation/provider/user_provider.dart';

class AISchedulePage extends ConsumerStatefulWidget {
  const AISchedulePage({super.key});

  @override
  ConsumerState<AISchedulePage> createState() => _AISchedulePageState();
}

class _AISchedulePageState extends ConsumerState<AISchedulePage> {
  late SurveyResponse surveyResponse;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    surveyResponse =
        ModalRoute.of(context)!.settings.arguments as SurveyResponse;
  }

  Future<String> _getPixabayImage(String destination) async {
    try {
      final city = destination.split('(')[0].trim();
      final query = Uri.encodeComponent(city);
      final response = await http.get(
        Uri.parse(
          'https://pixabay.com/api/?key=48447680-a9467e6fd874740328fcde2e3&q=$query&image_type=photo&category=travel&orientation=horizontal&per_page=3',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['hits'].isNotEmpty) {
          return data['hits'][0]['webformatURL'];
        }
      }
      return 'https://via.placeholder.com/640x480?text=No+Image';
    } catch (e) {
      return 'https://via.placeholder.com/640x480?text=Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        child: CircularProgressIndicator(),
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
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('뒤로가기'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, child) {
                        return ElevatedButton(
                          onPressed: () async {
                            try {
                              await _saveSchedule();
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('일정 저장 실패: $e')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          child: const Text('일정 담기',
                              style: TextStyle(color: Colors.white)),
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

  Future<void> _saveSchedule() async {
    try {
      final imageUrl = await _getPixabayImage(surveyResponse.selectedCity!);

      final schedule = Schedule(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: '${surveyResponse.selectedCity} 여행',
        location: surveyResponse.selectedCity!,
        duration: surveyResponse.travelDuration,
        imageUrl: imageUrl,
        isAIRecommended: true,
        travelStyle: surveyResponse.travelStyles.join(', '),
      );

      await ref.read(scheduleActionsProvider).addSchedule(schedule);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('일정이 저장되었습니다')),
        );
      }
    } catch (e) {
      print('Error saving schedule: $e');
    }
  }
}
