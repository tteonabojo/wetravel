import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wetravel/data/dto/package_dto.dart';

class UserDto {
  final String id;
  final String email;
  final String? password;
  final String? name;
  final String? imageUrl;
  final String? introduction;
  final String loginType;
  final bool isGuide;
  final Timestamp createdAt;
  final Timestamp? updatedAt;
  final Timestamp? deletedAt;
  final List<PackageDto>? scrapList;

  UserDto({
    required this.id,
    required this.email,
    required this.password,
    required this.name,
    required this.imageUrl,
    required this.introduction,
    required this.loginType,
    required this.isGuide,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.scrapList = const [],
  });

  UserDto copyWith({
    String? id,
    String? email,
    String? password,
    String? name,
    String? imageUrl,
    String? introduction,
    String? loginType,
    bool? isGuide,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    Timestamp? deletedAt,
    List<PackageDto>? scrapList,
  }) =>
      UserDto(
        id: id ?? this.id,
        email: email ?? this.email,
        password: password ?? this.password,
        name: name ?? this.name,
        imageUrl: imageUrl ?? this.imageUrl,
        introduction: introduction ?? this.introduction,
        loginType: loginType ?? this.loginType,
        isGuide: isGuide ?? this.isGuide,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt ?? this.deletedAt,
        scrapList: scrapList ?? this.scrapList,
      );

  UserDto.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'] as String,
          email: json['email'] as String,
          password: json['password'] as String,
          name: json['name'] as String,
          imageUrl: json['imageUrl'] as String,
          introduction: json['introduction'] as String,
          loginType: json['loginType'] as String,
          isGuide: json['isGuide'] as bool,
          createdAt: Timestamp.fromDate(DateTime.parse(json['createdAt'])),
          updatedAt: Timestamp.fromDate(DateTime.parse(json['updatedAt'])),
          deletedAt: json['deletedAt'] == null
              ? null
              : Timestamp.fromDate(DateTime.parse(json['deletedAt'])),
          scrapList:
              (json['scrapList'] == null ? [] : json['scrapList'] as List)
                  .map((e) => PackageDto.fromJson(e as Map<String, dynamic>))
                  .toList(),
        );
  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "password": password,
        "name": name,
        "imageUrl": imageUrl,
        "introduction": introduction,
        "loginType": loginType,
        "isGuide": isGuide,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "deletedAt": deletedAt,
        "scrapList": scrapList?.map((x) => x.toJson()).toList() ?? [],
      };
}
