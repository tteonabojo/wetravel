import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:wetravel/data/dto/user_dto.dart';

void main() {
  test(
    'UserDto : fromJson test',
    () {
      const sampleJsonString = """
{
      "id": "1",
      "email": "user1@gmail.com",
      "password": "password123",
      "name": "User 1",
      "imageUrl": "https://example.com/user1_image.jpg",
      "introduction": "I am a software engineer who loves traveling and meeting new people.",
      "loginType": "EMAIL",
      "createdAt": "2023-01-01 00:00:00",
      "updatedAt": "2023-01-01 00:00:00",
      "deletedAt": null,
      "scrapList": []
    }
""";
      final user = UserDto.fromJson(jsonDecode(sampleJsonString));
      expect(user.email, "user1@gmail.com");
    },
  );
}
