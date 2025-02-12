import 'package:wetravel/domain/entity/schedule.dart';

class TravelSchedule {
  final String destination;
  final List<DaySchedule> days;

  TravelSchedule({
    required this.destination,
    required this.days,
  });

  factory TravelSchedule.fromGeminiResponse(String response) {
    final List<DaySchedule> days = [];

    try {
      final dayBlocks = response.split('Day');
      for (var i = 1; i < dayBlocks.length; i++) {
        final schedules = <ScheduleItem>[];
        final lines = dayBlocks[i].split('\n');

        for (var j = 1; j < lines.length; j++) {
          final line = lines[j].trim();
          if (line.isEmpty) continue;

          final timeParts =
              RegExp(r'(\d{1,2}:\d{2})\s*[-–]\s*(.+)').firstMatch(line);
          if (timeParts != null) {
            final time = timeParts.group(1)!;
            final content = timeParts.group(2)!;

            final locationMatch = RegExp(r'@\s*(.+)$').firstMatch(content);
            final title = locationMatch != null
                ? content.substring(0, content.indexOf('@')).trim()
                : content.trim();
            final location = locationMatch?.group(1)?.trim() ?? '';

            schedules.add(ScheduleItem(
              time: time,
              title: title,
              location: location,
            ));
          }
        }

        if (schedules.isNotEmpty) {
          days.add(DaySchedule(schedules: schedules));
        }
      }
    } catch (e) {
      print('Error parsing schedule: $e');
    }

    return TravelSchedule(
      destination: '',
      days: days,
    );
  }

  // Firebase에서 데이터를 불러올 때 사용하는 팩토리 메서드
  factory TravelSchedule.fromFirestore(Map<String, dynamic> data) {
    final List<DaySchedule> days = (data['days'] as List).map((dayData) {
      final schedules = (dayData['schedules'] as List).map((scheduleData) {
        return ScheduleItem(
          time: scheduleData['time'],
          title: scheduleData['title'],
          location: scheduleData['location'],
        );
      }).toList();
      return DaySchedule(schedules: schedules);
    }).toList();

    return TravelSchedule(
      destination: data['destination'],
      days: days,
    );
  }

  Schedule toSchedule() {
    return Schedule(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: '${destination} 여행',
      location: destination,
      duration: days.length.toString(),
      imageUrl: '',
      day: days.length,
      isAIRecommended: true,
      travelStyle: '관광지',
      content: '',
      time: DateTime.now().toString(),
      packageId: '',
      order: 0,
    );
  }
}

class DaySchedule {
  final List<ScheduleItem> schedules;

  DaySchedule({required this.schedules});
}

class ScheduleItem {
  final String time;
  final String title;
  final String location;

  ScheduleItem({
    required this.time,
    required this.title,
    required this.location,
  });
}
