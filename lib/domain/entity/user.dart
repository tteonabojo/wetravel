import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wetravel/data/dto/user_dto.dart';
import 'package:wetravel/domain/entity/package.dart';

class User {
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
  final List<Package>? scrapList;
  final List<String>? scrapIdList;
  final List<String> recentPackages;

  String? displayName;

  User({
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
    this.scrapList,
    this.scrapIdList,
    required this.recentPackages,
  });

  factory User.fromDto(UserDto dto) {
    return User(
      id: dto.id,
      email: dto.email,
      password: dto.password,
      name: dto.name,
      imageUrl: dto.imageUrl,
      introduction: dto.introduction,
      loginType: dto.loginType,
      isAdmin: dto.isAdmin,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
      deletedAt: dto.deletedAt,
      scrapList: dto.scrapList?.map((e) => e.toEntity()).toList(),
      scrapIdList: dto.scrapIdList,
      recentPackages: dto.recentPackages,
    );
  }
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
  UserDto toDto() {
    return UserDto(
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
      scrapList: scrapList?.map((package) => package.toDto()).toList(),
      scrapIdList: scrapIdList,
      recentPackages: recentPackages,
    );
  }
}
