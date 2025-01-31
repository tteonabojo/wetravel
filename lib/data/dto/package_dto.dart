import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wetravel/data/dto/schedule_dto.dart';
import 'package:wetravel/domain/entity/package.dart';

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
  final List<String>? scheduleIdList;
  final Timestamp createdAt;
  final Timestamp? updatedAt;
  final Timestamp? deletedAt;
  final int reportCount;
  final bool isHidden;

  PackageDto({
    required this.id,
    required this.userId,
    required this.title,
    required this.location,
    this.description,
    this.duration,
    this.imageUrl,
    this.keywordList,
    this.schedule,
    this.scheduleIdList,
    required this.createdAt,
    this.updatedAt,
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
    List<String>? scheduleIdList,
    Timestamp? createdAt,
    Timestamp? updatedAt,
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
        scheduleIdList: scheduleIdList ?? this.scheduleIdList,
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
          scheduleIdList: List<String>.from(json['scheduleIdList']),
          createdAt: Timestamp.fromDate(DateTime.parse(json['createdAt'])),
          updatedAt: Timestamp.fromDate(DateTime.parse(json['updatedAt'])),
          deletedAt: json['deletedAt'] != null
              ? Timestamp.fromDate(DateTime.parse(json['deletedAt']))
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
        "scheduleIdList": scheduleIdList?.map((x) => x).toList() ?? [],
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "deletedAt": deletedAt,
        "reportCount": reportCount,
        "isHidden": isHidden,
      };

  Package toEntity() {
    return Package(
      id: id,
      userId: userId,
      title: title,
      location: location,
      description: description,
      duration: duration,
      imageUrl: imageUrl,
      keywordList: keywordList,
      schedule: schedule?.map((s) => s.toEntity()).toList(),
      scheduleIdList: scheduleIdList,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
      reportCount: reportCount,
      isHidden: isHidden,
    );
  }
}
