import 'package:wetravel/domain/entity/schedule.dart';

class ScheduleDto {
  final String id;
  final String packageId;
  final String title;
  final String? content;
  final String? imageUrl;
  final int order;

  ScheduleDto({
    required this.id,
    required this.packageId,
    required this.title,
    this.content,
    this.imageUrl,
    required this.order,
  });

  ScheduleDto copyWith({
    String? id,
    String? packageId,
    String? title,
    String? content,
    String? imageUrl,
    String? order,
  }) =>
      ScheduleDto(
        id: id ?? this.id,
        packageId: packageId ?? this.packageId,
        title: title ?? this.title,
        content: content ?? this.content,
        imageUrl: imageUrl ?? this.imageUrl,
        order: order as int,
      );

  /// JSON 데이터에서 객체 생성
  ScheduleDto.fromJson(Map<String, dynamic> json)
      : this(
          id: json["id"],
          packageId: json["packageId"],
          title: json["title"],
          content: json["content"],
          imageUrl: json["imageUrl"],
          order: json["order"],
        );

  /// 객체를 JSON으로 변환
  Map<String, dynamic> toJson() => {
        "id": id,
        "packageId": packageId,
        "title": title,
        "content": content,
        "imageUrl": imageUrl,
        "order": order,
      };

  Schedule toEntity() {
    return Schedule(
      id: id,
      packageId: packageId,
      title: title,
      content: content,
      imageUrl: imageUrl,
      order: order,
    );
  }
}
