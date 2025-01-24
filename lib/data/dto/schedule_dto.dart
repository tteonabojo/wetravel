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
        order: order ?? this.order,
      );

  /// JSON 데이터에서 객체 생성
  factory ScheduleDto.fromJson(Map<String, dynamic> json) => ScheduleDto(
        id: json["id"] as String? ?? 'unknown', // 기본값 'unknown'
        packageId: json["packageId"] as String? ?? 'unknown', // 기본값 'unknown'
        title: json["title"] as String? ?? 'No Title', // 기본값 'No Title'
        content: json["content"] as String?, // 선택적 필드
        imageUrl: json["imageUrl"] as String?, // 선택적 필드
        order: json["order"] as String? ?? '0', // 기본값 '0'
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
}