import 'package:cloud_firestore/cloud_firestore.dart';

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
}
