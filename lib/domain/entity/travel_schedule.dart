class TravelSchedule {
  final List<DaySchedule> days;

  TravelSchedule({required this.days});

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

    return TravelSchedule(days: days);
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
