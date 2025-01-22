import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:wetravel/data/dto/schedule_dto.dart';

void main() {
  test(
    'ScheduleDto : fromJson test',
    () {
      const sampleJsonString = """
{
      "id": "schedule_2",
      "packageId": "pkg_18",
      "title": "속초해수욕장",
      "content": "속초의 탁트인 바다전경을 소개해드립니다.",
      "imageUrl": "https://example.com/haeundae.jpg",
      "order": "1"
    }
""";

      final schedule = ScheduleDto.fromJson(jsonDecode(sampleJsonString));
      expect(schedule.title, "속초해수욕장");
    },
  );
}