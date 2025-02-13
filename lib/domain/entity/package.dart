import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wetravel/data/dto/package_dto.dart';

class Package {
  final String id;
  final String userId;
  final String? userName;
  final String? userImageUrl;
  final String title;
  final String location;
  final String? description;
  final String? duration;
  final String? imageUrl;
  final List<String>? keywordList;
  final List<String>? scheduleIdList;
  final Timestamp createdAt;
  final Timestamp? updatedAt;
  final Timestamp? deletedAt;
  final int reportCount;
  final bool isHidden;
  final int viewCount;

  Package({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userImageUrl,
    required this.title,
    required this.location,
    this.description,
    this.duration,
    this.imageUrl,
    this.keywordList,
    this.scheduleIdList,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.reportCount = 0,
    this.isHidden = false,
    this.viewCount = 0,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      id: json["id"] as String,
      userId: json["userId"] as String,
      userName: json["userName"] as String?,
      userImageUrl: json["userImageUrl"] as String?,
      title: json["title"] as String,
      location: json["location"] as String,
      description: json["description"] as String?,
      duration: json["duration"] as String?,
      imageUrl: json["imageUrl"] as String?,
      keywordList: (json["keywordList"] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      scheduleIdList: (json["scheduleIdList"] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      createdAt: json["createdAt"] as Timestamp,
      updatedAt: json["updatedAt"] as Timestamp?,
      deletedAt: json["deletedAt"] as Timestamp?,
      reportCount: json["reportCount"] as int? ?? 0,
      isHidden: json["isHidden"] as bool? ?? false,
      viewCount: json["viewCount"] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "userName": userName,
        "userImageUrl": userImageUrl,
        "title": title,
        "location": location,
        "description": description,
        "duration": duration,
        "imageUrl": imageUrl,
        "keywordList": List<dynamic>.from(keywordList!.map((x) => x)),
        "scheduleIdList": List<dynamic>.from(scheduleIdList!.map((x) => x)),
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "deletedAt": deletedAt,
        "reportCount": reportCount,
        "isHidden": isHidden,
        "viewCount": viewCount,
      };

  factory Package.fromDto(PackageDto dto) {
    return Package(
      id: dto.id,
      userId: dto.userId,
      userName: dto.userName,
      userImageUrl: dto.userImageUrl,
      title: dto.title,
      location: dto.location,
      description: dto.description,
      duration: dto.duration,
      imageUrl: dto.imageUrl,
      keywordList: dto.keywordList,
      scheduleIdList: dto.scheduleIdList,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
      deletedAt: dto.deletedAt,
      reportCount: dto.reportCount,
      isHidden: dto.isHidden,
      viewCount: dto.viewCount,
    );
  }

  PackageDto toDto() {
    return PackageDto(
      id: id,
      userId: userId,
      userName: userName ?? '',
      userImageUrl: userImageUrl ?? '',
      title: title,
      location: location,
      description: description,
      duration: duration,
      imageUrl: imageUrl,
      keywordList: keywordList ?? [],
      scheduleIdList: scheduleIdList ?? [],
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
      reportCount: reportCount,
      isHidden: isHidden,
      viewCount: viewCount,
    );
  }
}
