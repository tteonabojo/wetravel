import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:wetravel/data/dto/schedule_dto.dart';

void main() {
  test(
    'ScheduleDto : fromJson test',
    () {
      const sampleJsonString = """
{
      "id": "sch_3",
      "packageId": "pkg_2",
      "title": "해운대 해수욕장",
      "content": "부산의 대표 해수욕장인 해운대에서 바다를 즐깁니다.",
      "imageUrl": "https://example.com/haeundae.jpg",
      "order": 1
    }
""";

      final schedule = ScheduleDto.fromJson(jsonDecode(sampleJsonString));
      expect(schedule.title, "해운대 해수욕장");
    },
  );
}
