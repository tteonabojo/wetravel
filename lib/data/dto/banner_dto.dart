import 'package:cloud_firestore/cloud_firestore.dart';

class BannerDto {
  final String id;
  final String imageUrl;
  final String? linkUrl;
  final bool isHidden;
  final Timestamp? startDate;
  final Timestamp? endDate;
  final String? company;
  final String? description;
  final int? order;

  BannerDto({
    required this.id,
    required this.imageUrl,
    this.isHidden = false,
    this.linkUrl,
    this.startDate,
    this.endDate,
    this.company,
    this.description,
    this.order,
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
          id: json['id'],
          linkUrl: json['linkUrl'],
          imageUrl: json['imageUrl'],
          company: json['company'],
          description: json['description'],
          startDate: json['startDate'],
          endDate: json['endDate'],
          isHidden: json['isHidden'],
          order: json['order'],
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
