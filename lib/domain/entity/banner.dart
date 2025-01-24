import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wetravel/data/dto/banner_dto.dart';

class Banner {
  final String id;
  final String linkUrl;
  final String imageUrl;
  final Timestamp startDate;
  final Timestamp endDate;
  final bool isHidden;
  final String? company;
  final String? description;
  final int order;

  Banner({
    required this.id,
    required this.linkUrl,
    required this.imageUrl,
    required this.startDate,
    required this.endDate,
    required this.isHidden,
    required this.company,
    required this.description,
    required this.order,
  });

  factory Banner.fromDto(BannerDto dto) => Banner(
        id: dto.id,
        linkUrl: dto.linkUrl,
        imageUrl: dto.imageUrl,
        // 날짜 형식 변환 (예시)
        startDate: Timestamp.fromDate(DateTime.parse(dto.startDate as String)),
        endDate: Timestamp.fromDate(DateTime.parse(dto.endDate as String)),
        isHidden: dto.isHidden,
        company: dto.company,
        description: dto.description,
        order: dto.order,
      );
}
