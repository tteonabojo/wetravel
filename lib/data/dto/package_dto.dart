import 'package:wetravel/data/dto/schedule_dto.dart';

class PackageDto {
  final String id;
  final String userId;
  final String title;
  final String location;
  final String? description;
  final String? duration;
  final String? imageUrl;
  final List<String>? keywordList;
  final List<ScheduleDto>? schedule;
  final DateTime createdAt;
  final DateTime? updatedAt;
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

  PackageDto copyWith({
    String? id,
    String? userId,
    String? title,
    String? location,
    String? description,
    String? duration,
    String? imageUrl,
    List<String>? keywordList,
    List<ScheduleDto>? schedule,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic deletedAt,
    int? reportCount,
    bool? isHidden,
  }) =>
      PackageDto(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        title: title ?? this.title,
        location: location ?? this.location,
        description: description ?? this.description,
        duration: duration ?? this.duration,
        imageUrl: imageUrl ?? this.imageUrl,
        keywordList: keywordList ?? this.keywordList,
        schedule: schedule ?? this.schedule,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt ?? this.deletedAt,
        reportCount: reportCount ?? this.reportCount,
        isHidden: isHidden ?? this.isHidden,
      );

  PackageDto.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'] as String,
          userId: json['userId'] as String,
          title: json['title'] as String,
          location: json['location'] as String,
          description: json['description'] as String,
          duration: json['duration'] as String,
          imageUrl: json['imageUrl'] as String,
          keywordList: List<String>.from(json['keywordList'] as List),
          schedule: (json['schedule'] as List)
              .map((e) => ScheduleDto.fromJson(e as Map<String, dynamic>))
              .toList(),
          createdAt: DateTime.parse(json['createdAt']),
          updatedAt: DateTime.parse(json['updatedAt']),
          deletedAt: json['deletedAt'] != null
              ? DateTime.parse(json['deletedAt'])
              : null,
          reportCount: json['reportCount'] as int,
          isHidden: json['isHidden'] as bool,
        );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "title": title,
        "location": location,
        "description": description,
        "duration": duration,
        "imageUrl": imageUrl,
        "keywordList": keywordList?.map((x) => x).toList() ?? [],
        "schedule": schedule?.map((x) => x.toJson()).toList() ?? [],
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "deletedAt": deletedAt,
        "reportCount": reportCount,
        "isHidden": isHidden,
      };
}
