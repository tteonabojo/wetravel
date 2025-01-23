import 'package:wetravel/domain/entity/package.dart';

class User {
  final String id;
  final String email;
  final String? password;
  final String name;
  final String? imageUrl;
  final String? introduction;
  final String loginType;
  final bool isGuide;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final List<Package>? scrapList;

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
    this.scrapList = const [],
  });
}
