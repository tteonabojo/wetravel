import 'package:wetravel/data/dto/schedule_dto.dart';

class Schedule {
  final String id;
  final String title;
  final String location;
  final String duration;
  final String imageUrl;
  final int day;
  final bool isAIRecommended;
  final String travelStyle;
  final String content;
  final String time;
  final String packageId;
  final int order;

  Schedule({
    required this.id,
    required this.title,
    required this.location,
    required this.duration,
    required this.imageUrl,
    required this.day,
    required this.isAIRecommended,
    required this.travelStyle,
    required this.content,
    required this.time,
    required this.packageId,
    required this.order,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'location': location,
        'duration': duration,
        'imageUrl': imageUrl,
        'isAIRecommended': isAIRecommended,
        'travelStyle': travelStyle,
        'day': day,
        'content': content,
        'time': time,
        'packageId': packageId,
        'order': order,
      };

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
        id: json['id'] as String? ?? '',
        title: json['title'] as String? ?? '',
        location: json['location'] as String? ?? '',
        duration: json['duration'] as String? ?? '',
        imageUrl: json['imageUrl'] as String? ?? '',
        isAIRecommended: json['isAIRecommended'] as bool? ?? false,
        travelStyle: json['travelStyle'] as String? ?? '',
        day: json['day'] as int? ?? 1,
        content: json['content'] as String? ?? '',
        time: json['time'] as String? ?? '',
        packageId: json['packageId'] as String? ?? '',
        order: json['order'] as int? ?? 0,
      );

  ScheduleDto toDto() {
    return ScheduleDto(
      id: id,
      title: title,
      location: location,
      duration: duration,
      imageUrl: imageUrl,
      isAIRecommended: isAIRecommended,
      travelStyle: travelStyle,
      day: day,
      content: content,
      time: time,
      packageId: packageId,
      order: order,
    );
  }
}

class DaySchedule {
  final List<TimeSchedule> schedules;

  DaySchedule({required this.schedules});

  Map<String, dynamic> toJson() => {
        'schedules': schedules.map((schedule) => schedule.toJson()).toList(),
      };

  factory DaySchedule.fromJson(Map<String, dynamic> json) => DaySchedule(
        schedules: (json['schedules'] as List)
            .map((schedule) => TimeSchedule.fromJson(schedule))
            .toList(),
      );
}

class TimeSchedule {
  final String time;
  final String title;
  final String location;

  TimeSchedule({
    required this.time,
    required this.title,
    this.location = '',
  });

  Map<String, dynamic> toJson() => {
        'time': time,
        'title': title,
        'location': location,
      };

  factory TimeSchedule.fromJson(Map<String, dynamic> json) => TimeSchedule(
        time: json['time'] as String,
        title: json['title'] as String,
        location: json['location'] as String? ?? '',
      );
}
