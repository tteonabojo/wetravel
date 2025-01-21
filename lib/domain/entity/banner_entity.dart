import 'package:wetravel/data/dto/banner_dto.dart';

class BannerEntity {
  final String id;
  final String linkUrl;
  final String imageUrl;
  final DateTime startDate;
  final DateTime endDate;
  final bool isHidden;
  final String company;
  final String description;
  final int order;

  BannerEntity({
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

  factory BannerEntity.fromDto(Bannerdto dto) {
    return BannerEntity(
      id: dto.id,
      linkUrl: dto.linkUrl,
      imageUrl: dto.imageUrl,
      // 날짜 형식 변환 (예시)
      startDate: DateTime.parse(dto.startDate as String),
      endDate: DateTime.parse(dto.endDate as String),
      isHidden: dto.isHidden,
      company: dto.company,
      description: dto.descripion,
      order: dto.order,
    );
  }
}