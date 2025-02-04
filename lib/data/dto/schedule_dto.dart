import 'package:wetravel/domain/entity/schedule.dart';

class ScheduleDto {
  final String id;
  final String packageId;
  final int day;
  final String time;
  final String title;
  final String location;
  final String? content;
  final String? imageUrl;
  final int order;

  ScheduleDto({
    required this.id,
    required this.packageId,
    required this.day,
    required this.time,
    required this.title,
    required this.location,
    this.content,
    this.imageUrl,
    required this.order,
  });

  ScheduleDto copyWith({
    String? id,
    String? packageId,
    int? day,
    String? time,
    String? title,
    String? location,
    String? content,
    String? imageUrl,
    int? order,
  }) =>
      ScheduleDto(
        id: id ?? this.id,
        packageId: packageId ?? this.packageId,
        day: day as int,
        time: time ?? this.time,
        title: title ?? this.title,
        location: location ?? this.location,
        content: content ?? this.content,
        imageUrl: imageUrl ?? this.imageUrl,
        order: order as int,
      );

  /// JSON 데이터에서 객체 생성
  ScheduleDto.fromJson(Map<String, dynamic> json)
      : this(
          id: json["id"],
          packageId: json["packageId"],
          day: json["day"],
          time: json["time"],
          title: json["title"],
          location: json["location"],
          content: json["content"],
          imageUrl: json["imageUrl"],
          order: json["order"],
        );

  /// 객체를 JSON으로 변환
  Map<String, dynamic> toJson() => {
        "id": id,
        "packageId": packageId,
        "day": day,
        "time": time,
        "title": title,
        "location": location,
        "content": content,
        "imageUrl": imageUrl,
        "order": order,
      };

  Schedule toEntity() {
    return Schedule(
      id: id,
      packageId: packageId,
      day: day,
      time: time,
      title: title,
      location: location,
      content: content ?? '',
      imageUrl: imageUrl ?? '',
      order: order,
    );
  }

  factory ScheduleDto.fromEntity(Schedule schedule) {
    return ScheduleDto(
      id: schedule.id,
      packageId: schedule.packageId,
      day: schedule.day,
      time: schedule.time,
      title: schedule.title,
      location: schedule.location,
      content: schedule.content,
      imageUrl: schedule.imageUrl,
      order: schedule.order,
    );
  }

  factory ScheduleDto.fromMap(Map<String, dynamic> map) {
    return ScheduleDto(
      id: map['id'],
      packageId: map['packageId'],
      day: map['day'],
      time: map['time'],
      title: map['title'],
      location: map['location'],
      content: map['content'],
      imageUrl: map['imageUrl'],
      order: map['order'],
    );
  }
}
