import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:wetravel/data/dto/package_dto.dart';

void main() {
  test(
    'PackageDto : fromJson test',
    () {
      const sampleJsonString = """
{
      "id": "pkg_5",
      "userId": "user_5",
      "title": "전주 한옥마을 & 맛집 여행",
      "location": "전주",
      "description": "전주 한옥마을의 고즈넉함과 맛있는 음식을 즐기는 여행",
      "duration": "2박 3일",
      "imageUrl": "https://example.com/jeonju.jpg",
      "keywordList": ["전주", "한옥마을", "맛집", "전통"],
      "schedule": [],
      "createdAt": "2023-10-30T11:00:00Z",
      "updatedAt": "2023-10-30T11:00:00Z",
      "deletedAt": null,
      "reportCount": 0,
      "isHidden": false
    }
""";
      final package = PackageDto.fromJson(jsonDecode(sampleJsonString));
      expect(package.location, "전주");
    },
  );
}
