import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wetravel/data/dto/package_dto.dart';
import 'package:wetravel/domain/entity/schedule.dart';

class Package {
  final String id;
  final String userId;
  final String title;
  final String location;
  final String? description;
  final String? duration;
  final String? imageUrl;
  final List<String>? keywordList;
  final List<Schedule>? schedule;
  final List<String>? scheduleIdList;
  final Timestamp createdAt;
  final Timestamp? updatedAt;
  final Timestamp? deletedAt;
  final int reportCount;
  final bool isHidden;

  Package({
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

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "title": title,
        "location": location,
        "description": description,
        "duration": duration,
        "imageUrl": imageUrl,
        "keywordList": List<dynamic>.from(keywordList!.map((x) => x)),
        "schedule": List<dynamic>.from(schedule!.map((x) => x)),
        "scheduleIdList": List<dynamic>.from(scheduleIdList!.map((x) => x)),
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "deletedAt": deletedAt,
        "reportCount": reportCount,
        "isHidden": isHidden,
      };

  PackageDto toDto() {
    return PackageDto(
      id: id,
      userId: userId,
      title: title,
      location: location,
      description: description,
      duration: duration,
      imageUrl: imageUrl,
      keywordList: keywordList ?? [],
      schedule: schedule?.map((s) => s.toDto()).toList() ?? [],
      scheduleIdList: scheduleIdList ?? [],
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
      reportCount: reportCount,
      isHidden: isHidden,
    );
  }
}
