import 'package:wetravel/data/dto/package_dto.dart';

class UserDto {
  final String id;
  final String email;
  final String password;
  final String name;
  final String imageUrl;
  final String introduction;
  final String loginType;
  final bool isGuide;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final List<PackageDto> scrapList;

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

  factory UserDto.fromMap(Map<String, dynamic> data) {
    return UserDto(
      id: data['id'] as String,
      email: data['email'] as String,
      password: data['password'] as String,
      name: data['name'] as String,
      imageUrl: data['imageUrl'] as String,
      introduction: data['introduction'] as String,
      loginType: data['loginType'] as String,
      isGuide: data['isGuide'] as bool,
      createdAt: (data['createdAt']).toDate(),
      updatedAt: (data['updatedAt']).toDate(),
      deletedAt:
          data['deletedAt'] != null ? (data['deletedAt']).toDate() : null,
      scrapList: (data['scrapList'] as List)
          .map((e) => PackageDto.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
