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
  final bool isGuide;
  final Timestamp createdAt;
  final Timestamp? updatedAt;
  final Timestamp? deletedAt;
  final List<Package>? scrapList;

  String? displayName;

  User({
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
    this.scrapList,
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
      isGuide: dto.isGuide,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
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
        "isGuide": isGuide,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "deletedAt": deletedAt,
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
      isGuide: isGuide,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
      scrapList: scrapList?.map((package) => package.toDto()).toList(),
    );
  }
}
