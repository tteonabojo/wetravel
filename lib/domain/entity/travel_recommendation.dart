import 'dart:developer' as dev;

class TravelRecommendation {
  final List<String> destinations;
  final List<String> reasons;
  final List<String> tips;

  TravelRecommendation({
    required this.destinations,
    required this.reasons,
    required this.tips,
  });

  factory TravelRecommendation.fromGeminiResponse(String response) {
    dev.log('Parsing Gemini response: $response');

    try {
      final List<String> destinations = [];
      final Map<String, String> reasonsMap = {}; // 여행지별 이유
      final Map<String, String> tipsMap = {}; // 여행지별 팁

      // 응답을 줄 단위로 분리
      final lines = response.split('\n');
      String currentDestination = '';

      for (var line in lines) {
        line = line.trim();
        if (line.isEmpty) continue;

        // 마크다운과 특수문자 제거
        line = line.replaceAll('**', '').replaceAll('*', '');

        // 숫자로 시작하는 줄에서 도시 이름 추출
        final cityPattern = RegExp(r'^\d+\.\s*(.+?)(?:\s*-|$)');
        final cityMatch = cityPattern.firstMatch(line);
        if (cityMatch != null) {
          currentDestination = cityMatch.group(1)?.trim() ?? '';
          if (currentDestination.isNotEmpty) {
            destinations.add(currentDestination);
            dev.log('Found destination: $currentDestination');
          }
          continue;
        }

        if (currentDestination.isEmpty) continue;

        // 추천 이유와 팁 추출
        if (line.startsWith('-') || line.startsWith('•')) {
          final content = line.substring(1).trim().toLowerCase();

          if (content.contains('추천 이유:') || content.contains('이유:')) {
            final reason = content.split(':')[1].trim();
            reasonsMap[currentDestination] = reason;
            dev.log('Found reason for $currentDestination: $reason');
          } else if (content.contains('주의사항/팁:') ||
              content.contains('주의사항:') ||
              content.contains('팁:')) {
            final tip = content.split(':')[1].trim();
            tipsMap[currentDestination] = tip;
            dev.log('Found tip for $currentDestination: $tip');
          }
        }
      }

      dev.log('Parsed destinations: $destinations');
      dev.log('Parsed reasons: $reasonsMap');
      dev.log('Parsed tips: $tipsMap');

      // 파싱된 결과가 없으면 예외 발생
      if (destinations.isEmpty || reasonsMap.isEmpty) {
        throw Exception('응답을 파싱할 수 없습니다.');
      }

      // Map을 List로 변환
      final reasons = destinations.map((d) => reasonsMap[d] ?? '').toList();
      final tips =
          destinations.map((d) => tipsMap[d] ?? '주의사항이 없습니다.').toList();

      return TravelRecommendation(
        destinations: destinations,
        reasons: reasons,
        tips: tips,
      );
    } catch (e) {
      dev.log('Error parsing Gemini response: $e');
      throw Exception('응답을 파싱할 수 없습니다.');
    }
  }

  get otherDestinations => null;
}
