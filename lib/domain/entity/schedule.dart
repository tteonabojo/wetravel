import 'package:wetravel/data/dto/schedule_dto.dart';

class Schedule {
  final String id;
  final String
      packageId; // Assuming a package ID is associated with the schedule
  final String title;
  final String content;
  final String imageUrl;
  final int order;
  final bool isHidden; // Flag to indicate if the schedule is hidden

  Schedule({
    required this.id,
    required this.packageId,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.order,
    this.isHidden = false, // Set default value for isHidden
  });

  factory Schedule.fromDto(ScheduleDto dto) => Schedule(
        id: dto.id,
        packageId: dto.packageId,
        title: dto.title,
        content: dto.content,
        imageUrl: dto.imageUrl,
        order: int.parse(dto.order),
        isHidden:
            dto.isHidden ?? false, // Handle potential null value for isHidden
      );
}
