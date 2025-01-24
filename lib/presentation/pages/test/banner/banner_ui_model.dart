import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wetravel/domain/entity/banner.dart';

class BannerUiModel {
  final String id;
  final String linkUrl;
  final String imageUrl;
  final Timestamp startDateStr;
  final Timestamp endDateStr;
  final bool isHidden;
  final String? company;
  final String? description;
  final int order;

  BannerUiModel({
    required this.id,
    required this.linkUrl,
    required this.imageUrl,
    required this.startDateStr,
    required this.endDateStr,
    required this.isHidden,
    required this.company,
    required this.description,
    required this.order,
  });

  factory BannerUiModel.fromEntity(Banner entity) {
    return BannerUiModel(
      id: entity.id,
      linkUrl: entity.linkUrl,
      imageUrl: entity.imageUrl,
      startDateStr: entity.startDate,
      endDateStr: entity.endDate,
      isHidden: entity.isHidden,
      company: entity.company,
      description: entity.description,
      order: entity.order,
    );
  }
}
