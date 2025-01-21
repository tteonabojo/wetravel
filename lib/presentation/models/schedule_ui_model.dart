import 'package:wetravel/domain/entity/schedule_entity.dart';

class ScheduleUiModel {
  final String id;
  final String packageId;
  final String title;
  final String content;
  final String imageUrl;
  final int order;

  ScheduleUiModel({
    required this.id,
    required this.packageId,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.order,
  });

  factory ScheduleUiModel.fromEntity(ScheduleEntity entity) {
    return ScheduleUiModel(
      id: entity.id,
      packageId: entity.packageId,
      title: entity.title,
      content: entity.content,
      imageUrl: entity.imageUrl,
      order: entity.order,
    );
  }
}