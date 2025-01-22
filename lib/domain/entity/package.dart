import 'package:wetravel/domain/entity/schedule.dart';

class Package {
  final String id;
  final String userId;
  final String title;
  final String location;
  final String description;
  final String duration;
  final String imageUrl;
  final List<String> keywordList;
  final List<Schedule> schedule;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final int reportCount;
  final bool isHidden;

  Package({
    required this.id,
    required this.userId,
    required this.title,
    required this.location,
    required this.description,
    required this.duration,
    required this.imageUrl,
    required this.keywordList,
    required this.schedule,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.reportCount = 0,
    this.isHidden = false,
  });
}
