import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wetravel/domain/entity/package.dart';

class PackageDto {
  final String id;
  final String userId;
  final String userName;
  final String userImageUrl;
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

  PackageDto({
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

  PackageDto copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userImageUrl,
    String? title,
    String? location,
    String? description,
    String? duration,
    String? imageUrl,
    List<String>? keywordList,
    List<String>? scheduleIdList,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    dynamic deletedAt,
    int? reportCount,
    bool? isHidden,
    int? viewCount,
  }) =>
      PackageDto(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        userName: userName ?? this.userName,
        userImageUrl: userId ?? this.userImageUrl,
        title: title ?? this.title,
        location: location ?? this.location,
        description: description ?? this.description,
        duration: duration ?? this.duration,
        imageUrl: imageUrl ?? this.imageUrl,
        keywordList: keywordList ?? this.keywordList,
        scheduleIdList: scheduleIdList ?? this.scheduleIdList,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt ?? this.deletedAt,
        reportCount: reportCount ?? this.reportCount,
        isHidden: isHidden ?? this.isHidden,
        viewCount: viewCount ?? this.viewCount,
      );
  PackageDto.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'] ?? '',
          userId: json['userId'] ?? '',
          userName: json['userName'] ?? '',
          userImageUrl: json['userImageUrl'] ?? '',
          title: json['title'] ?? '',
          location: json['location'] ?? '',
          description: json['description'] ?? '',
          duration: json['duration'] ?? '',
          imageUrl: json['imageUrl'] ?? '',
          keywordList: List<String>.from(json['keywordList']),
          scheduleIdList: List<String>.from(json['scheduleIdList']),
          createdAt: json['createdAt'],
          updatedAt: json['updatedAt'],
          deletedAt: json['deletedAt'],
          reportCount: json['reportCount'] ?? 0,
          isHidden: json['isHidden'] ?? false,
          viewCount: json['viewCount'] ?? 0,
        );

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
        "keywordList": keywordList?.map((x) => x).toList() ?? [],
        "scheduleIdList": scheduleIdList?.map((x) => x).toList() ?? [],
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "deletedAt": deletedAt,
        "reportCount": reportCount,
        "isHidden": isHidden,
        "viewCount": viewCount,
      };

  factory PackageDto.fromEntity(Package package) {
    return PackageDto(
      id: package.id,
      userId: package.userId,
      userName: package.userName ?? '',
      userImageUrl: package.userImageUrl ?? '',
      title: package.title,
      location: package.location,
      description: package.description,
      duration: package.duration,
      imageUrl: package.imageUrl,
      keywordList: package.keywordList,
      scheduleIdList: package.scheduleIdList,
      createdAt: package.createdAt,
      updatedAt: package.updatedAt,
      deletedAt: package.deletedAt,
      reportCount: package.reportCount,
      isHidden: package.isHidden,
      viewCount: package.viewCount,
    );
  }

  Package toEntity() {
    return Package(
      id: id,
      userId: userId,
      userName: userName,
      userImageUrl: userImageUrl,
      title: title,
      location: location,
      description: description,
      duration: duration,
      imageUrl: imageUrl,
      keywordList: keywordList,
      scheduleIdList: scheduleIdList,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
      reportCount: reportCount,
      isHidden: isHidden,
      viewCount: viewCount,
    );
  }

  factory PackageDto.fromMap(Map<String, dynamic> map) {
    return PackageDto(
      id: map['id'],
      userId: map['userId'],
      userName: map['userName'] ?? '',
      userImageUrl: map['userImageUrl'] ?? '',
      title: map['title'],
      location: map['location'],
      description: map['description'] ?? '',
      duration: map['duration'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      keywordList: map['keywordList'] != null
          ? List<String>.from(map['keywordList'])
          : null,
      scheduleIdList: map['scheduleIdList'] != null
          ? List<String>.from(map['scheduleIdList'])
          : null,
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      deletedAt: map['deletedAt'],
      reportCount: map['reportCount'],
      isHidden: map['isHidden'],
      viewCount: map['viewCount'],
    );
  }
}
