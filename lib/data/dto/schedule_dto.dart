class ScheduleDto {
  final String id;
  final String packageId;
  final String title;
  final String? content;
  final String? imageUrl;
  final String order;

  ScheduleDto({
    required this.id,
    required this.packageId,
    required this.title,
    required this.content,
    required this.imageUrl,
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
        order: order ?? this.order,
      );

  factory ScheduleDto.fromJson(Map<String, dynamic> json) => ScheduleDto(
        id: json["id"],
        packageId: json["packageId"],
        title: json["title"],
        content: json["content"],
        imageUrl: json["imageUrl"],
        order: json["order"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "packageId": packageId,
        "title": title,
        "content": content,
        "imageUrl": imageUrl,
        "order": order,
      };
}
