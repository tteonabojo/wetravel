import 'package:wetravel/data/dto/schedule_dto.dart';

class Schedule {
  final String id;
  final String packageId;
  final int day;
  final String time;
  final String title;
  final String location;
  final String content;
  final String imageUrl;
  final int order;

  Schedule({
    required this.id,
    required this.packageId,
    required this.day,
    required this.time,
    required this.title,
    required this.location,
    required this.content,
    required this.imageUrl,
    required this.order,
  });

  factory Schedule.fromDto(ScheduleDto dto) {
    return Schedule(
      id: dto.id,
      packageId: dto.packageId,
      day: dto.day,
      time: dto.time,
      title: dto.title,
      location: dto.location,
      content: dto.content!,
      imageUrl: dto.imageUrl!,
      order: dto.order,
    );
  }

  ScheduleDto toDto() {
    return ScheduleDto(
      id: id,
      packageId: packageId,
      day: day,
      time: time,
      title: title,
      location: location,
      content: content,
      imageUrl: imageUrl,
      order: order,
    );
  }
}
