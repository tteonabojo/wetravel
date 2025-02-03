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
