import 'package:wetravel/data/dto/schedule_dto.dart';

class Schedule {
  final String id;
  final String packageId;
  final String title;
  final String? content;
  final String? imageUrl;
  final int order;

  Schedule({
    required this.id,
    required this.packageId,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.order,
  });
  ScheduleDto toDto() {
    return ScheduleDto(
      id: id,
      packageId: packageId,
      title: title,
      content: content,
      imageUrl: imageUrl,
      order: order,
    );
  }
}
