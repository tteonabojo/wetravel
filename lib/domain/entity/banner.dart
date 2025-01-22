import 'package:wetravel/data/dto/banner_dto.dart';

class Banner {
  final String id;
  final String linkUrl;
  final String imageUrl;
  final DateTime startDate;
  final DateTime endDate;
  final bool isHidden;
  final String company;
  final String description;
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

  factory Banner.fromDto(BannerDto dto) {
    return Banner(
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
