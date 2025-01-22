class ScheduleDto {
  final String id;
  final String packageId;
  final String title;
  final String content;
  final String imageUrl;
  final String order;

  ScheduleDto({
    required this.id,
    required this.packageId,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.order,
  });

  factory ScheduleDto.fromJson(Map<String, dynamic> json) {
    return ScheduleDto(
      id: json['id'] as String,
      packageId: json['packageId'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      imageUrl: json['imageUrl'] as String,
      order: json['order'] as String,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'packageId': packageId,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'order': order,
    };
  }
}
