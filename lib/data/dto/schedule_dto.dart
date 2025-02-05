import 'package:wetravel/domain/entity/schedule.dart';

class ScheduleDto {
  final String id;
  final String packageId;
  final int day;
  final String time;
  final String title;
  final String location;
  final String duration;
  final String imageUrl;
  final bool isAIRecommended;
  final String travelStyle;
  final String? content;
  final int order;

  ScheduleDto({
    required this.id,
    required this.packageId,
    required this.day,
    required this.time,
    required this.title,
    required this.location,
    required this.duration,
    required this.imageUrl,
    required this.isAIRecommended,
    required this.travelStyle,
    required this.content,
    required this.order,
  });

  ScheduleDto copyWith({
    String? id,
    String? packageId,
    int? day,
    String? time,
    String? title,
    String? location,
    String? duration,
    String? imageUrl,
    bool? isAIRecommended,
    String? travelStyle,
    String? content,
    int? order,
  }) =>
      ScheduleDto(
        id: id ?? this.id,
        packageId: packageId ?? this.packageId,
        day: day ?? this.day,
        time: time ?? this.time,
        title: title ?? this.title,
        location: location ?? this.location,
        duration: duration ?? this.duration,
        imageUrl: imageUrl ?? this.imageUrl,
        isAIRecommended: isAIRecommended ?? this.isAIRecommended,
        travelStyle: travelStyle ?? this.travelStyle,
        content: content ?? this.content,
        order: order ?? this.order,
      );

  /// JSON 데이터에서 객체 생성
  factory ScheduleDto.fromJson(Map<String, dynamic> json) {
    return ScheduleDto(
      id: json['id'] ?? '',
      packageId: json['packageId'] ?? '',
      day: json['day'] ?? 0,
      time: json['time'] ?? '',
      title: json['title'] ?? '',
      location: json['location'] ?? '',
      duration: json['duration'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      isAIRecommended: json['isAIRecommended'] ?? false,
      travelStyle: json['travelStyle'] ?? '',
      content: json['content'] ?? '',
      order: json['order'] ?? 0,
    );
  }

  /// 객체를 JSON으로 변환
  Map<String, dynamic> toJson() => {
        'id': id,
        'packageId': packageId,
        'day': day,
        'time': time,
        'title': title,
        'location': location,
        'duration': duration,
        'imageUrl': imageUrl,
        'isAIRecommended': isAIRecommended,
        'travelStyle': travelStyle,
        'content': content,
        'order': order,
      };

  Schedule toEntity() {
    return Schedule(
      id: id,
      packageId: packageId,
      day: day,
      time: time,
      title: title,
      location: location,
      duration: duration,
      imageUrl: imageUrl,
      isAIRecommended: isAIRecommended,
      travelStyle: travelStyle,
      content: content,
      order: order,
    );
  }

  factory ScheduleDto.fromEntity(Schedule schedule) {
    return ScheduleDto(
      id: schedule.id,
      packageId: schedule.packageId ?? '',
      day: schedule.day ?? 0,
      time: schedule.time ?? '',
      title: schedule.title,
      location: schedule.location,
      duration: schedule.duration,
      imageUrl: schedule.imageUrl,
      isAIRecommended: schedule.isAIRecommended,
      travelStyle: schedule.travelStyle,
      content: schedule.content,
      order: schedule.order ?? 0,
    );
  }
}

class DayScheduleDto {
  final List<TimeScheduleDto> schedules;

  DayScheduleDto({required this.schedules});

  Map<String, dynamic> toJson() => {
        'schedules': schedules.map((schedule) => schedule.toJson()).toList(),
      };

  factory DayScheduleDto.fromJson(Map<String, dynamic> json) => DayScheduleDto(
        schedules: (json['schedules'] as List)
            .map((schedule) => TimeScheduleDto.fromJson(schedule))
            .toList(),
      );

  DaySchedule toEntity() => DaySchedule(
        schedules: schedules.map((schedule) => schedule.toEntity()).toList(),
      );

  factory DayScheduleDto.fromEntity(DaySchedule schedule) => DayScheduleDto(
        schedules: schedule.schedules
            .map((schedule) => TimeScheduleDto.fromEntity(schedule))
            .toList(),
      );
}

class TimeScheduleDto {
  final String time;
  final String title;
  final String location;

  TimeScheduleDto({
    required this.time,
    required this.title,
    this.location = '',
  });

  Map<String, dynamic> toJson() => {
        'time': time,
        'title': title,
        'location': location,
      };

  factory TimeScheduleDto.fromJson(Map<String, dynamic> json) =>
      TimeScheduleDto(
        time: json['time'] as String,
        title: json['title'] as String,
        location: json['location'] as String? ?? '',
      );

  TimeSchedule toEntity() => TimeSchedule(
        time: time,
        title: title,
        location: location,
      );

  factory TimeScheduleDto.fromEntity(TimeSchedule schedule) => TimeScheduleDto(
        time: schedule.time,
        title: schedule.title,
        location: schedule.location,
      );
}
