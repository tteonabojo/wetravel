import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:wetravel/data/dto/banner_dto.dart';

void main() {
  test(
    'BannerDto : fromJson test',
    () {
      const sampleJsonString = """
{
      "id": "banner_1",
      "linkUrl": "https://www.example1.com",
      "imageUrl": "https://example.com/banner1.jpg",
      "company": "Example Company 1",
      "description": "새로운 상품 출시!",
      "startDate": "2023-11-01T00:00:00Z",
      "endDate": "2023-11-30T23:59:59Z",
      "isHidden": false,
      "order": 1
    }
""";

      final banner = BannerDto.fromJson(jsonDecode(sampleJsonString));
      expect(banner.company, "Example Company 1");
    },
  );
}
