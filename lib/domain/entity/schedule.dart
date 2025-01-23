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

  factory Schedule.fromDto(ScheduleDto dto) => Schedule(
        id: dto.id,
        packageId: dto.packageId,
        title: dto.title,
        content: dto.content,
        imageUrl: dto.imageUrl,
        order: int.parse(dto.order),
      );
}
