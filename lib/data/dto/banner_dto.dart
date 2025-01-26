import 'package:cloud_firestore/cloud_firestore.dart';

class BannerDto {
  final String id;
  final String linkUrl;
  final String imageUrl;
  final String? company;
  final String? description;
  final Timestamp startDate;
  final Timestamp endDate;
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
    Timestamp? startDate,
    Timestamp? endDate,
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

  BannerDto.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'] as String,
          linkUrl: json['linkUrl'] as String,
          imageUrl: json['imageUrl'] as String,
          company: json['company'] as String,
          description: json['description'] as String,
          startDate: Timestamp.fromDate(DateTime.parse(json['startDate'])),
          endDate: Timestamp.fromDate(DateTime.parse(json['endDate'])),
          isHidden: json['isHidden'] as bool,
          order: json['order'] as int,
        );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'linkUrl': linkUrl,
      'imageUrl': imageUrl,
      'company': company,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'isHidden': isHidden,
      'order': order,
    };
  }
}
