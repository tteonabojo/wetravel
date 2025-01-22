class BannerDto {
  final String id;
  final String linkUrl;
  final String imageUrl;
  final String company;
  final String description;
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

  factory BannerDto.fromJson(Map<String, dynamic> json) {
    return BannerDto(
      id: json['id'] as String,
      linkUrl: json['linkUrl'] as String,
      imageUrl: json['imageUrl'] as String,
      company: json['company'] as String,
      description: json['description'] as String,
      startDate: json['startDate'] as DateTime,
      endDate: json['endDate'] as DateTime,
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
      'descripion': description,
      'startDate': startDate,
      'endDate': endDate,
      'isHidden': isHidden,
      'order': order,
    };
  }
}