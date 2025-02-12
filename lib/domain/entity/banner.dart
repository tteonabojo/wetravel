import 'package:cloud_firestore/cloud_firestore.dart';

class Banner {
  final String id;
  final String imageUrl;
  final String? linkUrl;
  final bool isHidden;
  final Timestamp? startDate;
  final Timestamp? endDate;
  final String? company;
  final String? description;
  final int? order;

  Banner({
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
}
