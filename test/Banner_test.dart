import 'package:flutter_test/flutter_test.dart';
import 'package:wetravel/domain/entity/banner.dart';
import 'package:wetravel/data/dto/banner_dto.dart';

void main() {
  group('Banner fromDto test', () {
    test('should create Banner from BannerDto', () {
      // Given
      final bannerDto = BannerDto(
        id: '1',
        linkUrl: 'https://www.example.com',
        // ... 나머지 필드 설정
      );

      // When
      final banner = Banner.fromDto(bannerDto);

      // Then
      expect(banner.id, '1');
      expect(banner.linkUrl, 'https://www.example.com');
      // ... 나머지 필드 비교
    });

    // 다른 테스트 케이스 추가 (예: 비정상적인 데이터 입력 시 예외 발생 확인 등)
  });
}