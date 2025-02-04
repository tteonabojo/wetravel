import 'dart:developer' as dev;

class TravelRecommendation {
  final List<String> destinations;
  List<String> reasons;
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
      final List<String> reasons = [];
      final List<String> tips = [];

      // 응답을 줄 단위로 분리
      final lines = response.split('\n');

      for (var line in lines) {
        line = line.trim();
        if (line.isEmpty) continue;

        // 마크다운과 특수문자 제거
        line = line.replaceAll('**', '').replaceAll('*', '');

        // 도시, 이유, 팁 추출을 위한 정규식
        final pattern = RegExp(
            r'^\d+\.\s*([^-]+)-\s*추천 이유:\s*([^/]+)\s*/\s*주의사항:?\s*(.+)$');
        final match = pattern.firstMatch(line);

        if (match != null) {
          destinations.add(match.group(1)?.trim() ?? '');
          reasons.add(match.group(2)?.trim() ?? '');
          tips.add(match.group(3)?.trim() ?? '');
        }
      }

      if (destinations.isEmpty || reasons.isEmpty || tips.isEmpty) {
        throw Exception('응답을 파싱할 수 없습니다.');
      }

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
