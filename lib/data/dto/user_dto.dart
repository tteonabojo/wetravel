import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wetravel/data/dto/package_dto.dart';
import 'package:wetravel/domain/entity/user.dart';

class UserDto {
  final String id;
  final String email;
  final String? password;
  final String? name;
  final String? imageUrl;
  final String? introduction;
  final String loginType;
  final bool isAdmin;
  final Timestamp createdAt;
  final Timestamp? updatedAt;
  final Timestamp? deletedAt;
  final List<PackageDto>? scrapList;
  final List<String>? scrapIdList;
  final List<String> recentPackages;

  UserDto({
    required this.id,
    required this.email,
    this.password,
    this.name,
    this.imageUrl,
    this.introduction,
    required this.loginType,
    required this.isAdmin,
    required this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.scrapList = const [],
    this.scrapIdList = const [],
    required this.recentPackages,
  });

  UserDto copyWith({
    String? id,
    String? email,
    String? password,
    String? name,
    String? imageUrl,
    String? introduction,
    String? loginType,
    bool? isAdmin,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    Timestamp? deletedAt,
    List<PackageDto>? scrapList,
    List<String>? scrapIdList,
    List<String>? recentPackages,
  }) =>
      UserDto(
        id: id ?? this.id,
        email: email ?? this.email,
        password: password ?? this.password,
        name: name ?? this.name,
        imageUrl: imageUrl ?? this.imageUrl,
        introduction: introduction ?? this.introduction,
        loginType: loginType ?? this.loginType,
        isAdmin: isAdmin ?? this.isAdmin,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt ?? this.deletedAt,
        scrapList: scrapList ?? this.scrapList,
        scrapIdList: scrapIdList ?? this.scrapIdList,
        recentPackages: recentPackages ?? this.recentPackages,
      );

  UserDto.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'] as String,
          email: json['email'] as String,
          password: json['password'] as String?,
          name: json['name'] ?? '',
          imageUrl: json['imageUrl'] ?? '',
          introduction: json['introduction'] as String?,
          loginType: json['loginType'] as String,
          isAdmin: json['isAdmin'],
          createdAt: json['createdAt'] as Timestamp,
          updatedAt:
              json['updatedAt'] != null ? json['updatedAt'] as Timestamp : null,
          deletedAt:
              json['deletedAt'] != null ? json['updatedAt'] as Timestamp : null,
          scrapList: json['scrapList'] != null
              ? (json['scrapList'] as List)
                  .map((e) => PackageDto.fromJson(e as Map<String, dynamic>))
                  .toList()
              : [],
          scrapIdList: json['scrapIdList'] != null
              ? List<String>.from(json['scrapIdList'] as List)
              : [],
          recentPackages: json['recentPackages'] != null
              ? List<String>.from(json['recentPackages'] as List)
              : [],
        );
  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "password": password,
        "name": name,
        "imageUrl": imageUrl,
        "introduction": introduction,
        "loginType": loginType,
        "isAdmin": isAdmin,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "deletedAt": deletedAt,
        "scrapList": scrapList?.map((e) => e.toJson()).toList(),
        "scrapIdList": scrapIdList,
        "recentPackages": recentPackages,
      };

  User toEntity() {
    return User(
      id: id,
      email: email,
      password: password,
      name: name,
      imageUrl: imageUrl,
      introduction: introduction,
      loginType: loginType,
      isAdmin: isAdmin,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
      scrapList: scrapList?.map((e) => e.toEntity()).toList(),
      scrapIdList: scrapIdList,
      recentPackages: recentPackages,
    );
  }
}
