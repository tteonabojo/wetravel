import 'package:wetravel/data/dto/schedule_dto.dart';

class PackageDto {
  final String id;
  final String userId;
  final String title;
  final String location;
  final String description;
  final String duration;
  final String imageUrl;
  final List<String> keywordList;
  final List<ScheduleDto> schedule;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final int reportCount;
  final bool isHidden;

  PackageDto({
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

  PackageDto.fromMap(Map<String, dynamic> map)
      : this(
          id: map['id'] as String,
          userId: map['userId'] as String,
          title: map['title'] as String,
          location: map['location'] as String,
          description: map['description'] as String,
          duration: map['duration'] as String,
          imageUrl: map['imageUrl'] as String,
          keywordList: List<String>.from(map['keywordList'] as List),
          schedule: (map['schedule'] as List)
              .map((e) => ScheduleDto.fromMap(e as Map<String, dynamic>))
              .toList(),
          createdAt: (map['createdAt']).toDate(),
          updatedAt: (map['updatedAt']).toDate(),
          deletedAt:
              map['deletedAt'] != null ? (map['deletedAt']).toDate() : null,
          reportCount: map['reportCount'] as int,
          isHidden: map['isHidden'] as bool,
        );
}
