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
    this.userName,
    this.userImageUrl,
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

  PackageDto toDto() {
    return PackageDto(
      id: id,
      userId: userId,
      userName: userName,
      userImageUrl: userImageUrl,
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
