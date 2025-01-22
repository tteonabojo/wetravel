class BannerDto {
  final String id;
  final String linkUrl;
  final String imageUrl;
  final String? company;
  final String? description;
  final DateTime startDate;
  final DateTime endDate;
  final bool isHidden;
  final int order;

  BannerDto({
    required this.id,
    required this.linkUrl,
    required this.imageUrl,
    required this.company,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.isHidden,
    required this.order,
  });

  BannerDto copyWith({
    String? id,
    String? linkUrl,
    String? imageUrl,
    String? company,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    bool? isHidden,
    int? order,
  }) =>
      BannerDto(
        id: id ?? this.id,
        linkUrl: linkUrl ?? this.linkUrl,
        imageUrl: imageUrl ?? this.imageUrl,
        company: company ?? this.company,
        description: description ?? this.description,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        isHidden: isHidden ?? this.isHidden,
        order: order ?? this.order,
      );

  factory BannerDto.fromJson(Map<String, dynamic> json) {
    return BannerDto(
      id: json['id'] as String,
      linkUrl: json['linkUrl'] as String,
      imageUrl: json['imageUrl'] as String,
      company: json['company'] as String,
      description: json['description'] as String,
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      isHidden: json['isHidden'] as bool,
      order: json['order'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'linkUrl': linkUrl,
      'imageUrl': imageUrl,
      'company': company,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isHidden': isHidden,
      'order': order,
    };
  }
}
