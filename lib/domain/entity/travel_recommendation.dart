import 'dart:developer' as dev;

class TravelRecommendation {
  final List<String> destinations;
  final List<String> reasons;
  final List<String> tips;
  final List<String> preferredCities;

  TravelRecommendation({
    required this.destinations,
    required this.reasons,
    required this.tips,
    this.preferredCities = const [],
  });

  factory TravelRecommendation.fromGeminiResponse(
    String response, {
    List<String> preferredCities = const [],
  }) {
    List<String> destinations = [];
    List<String> reasons = [];
    List<String> categories = [];

    try {
      final sections = response.split('---');
      print('Number of sections: ${sections.length}'); // 디버깅 로그 추가

      for (var section in sections) {
        if (section.trim().isEmpty) continue;

        final cityMatch =
            RegExp(r'도시명:\s*\**([^*\n]+)\**(?=\n|$)').firstMatch(section);
        final categoryMatch =
            RegExp(r'카테고리:\s*\**([^*\n]+)\**(?=\n|$)').firstMatch(section);
        final reasonMatch =
            RegExp(r'추천 이유:\s*\**([^*\n]+)\**(?=\n|$)').firstMatch(section);

        if (cityMatch != null && reasonMatch != null) {
          final cityWithCountry = cityMatch.group(1)?.trim() ?? '';
          final category = categoryMatch?.group(1)?.trim() ?? '';
          final reason = reasonMatch.group(1)?.trim() ?? '';

          if (cityWithCountry.isNotEmpty && reason.isNotEmpty) {
            destinations.add(cityWithCountry);
            reasons.add(reason);
            categories.add(category);
          }
        }
      }

      print('Parsed destinations: $destinations'); // 디버깅 로그 추가
      print('Parsed reasons: $reasons'); // 디버깅 로그 추가

      // 선호하는 도시가 있는 경우에만 처리
      if (preferredCities.isNotEmpty) {
        final preferredCity = preferredCities.first;
        print('Processing preferred city: $preferredCity');

        final index = destinations.indexWhere((d) =>
            d.toLowerCase().split(',').first.trim() ==
            preferredCity.toLowerCase());

        print('Found preferred city at index: $index');

        if (index == -1) {
          print('Adding preferred city to recommendations');
          destinations.insert(0, '$preferredCity, 대한민국');
          reasons.insert(0, '사용자가 선택한 선호 도시입니다.');
          categories.insert(0, categories.firstOrNull ?? '일반 관광지');
        } else if (index > 0) {
          final city = destinations.removeAt(index);
          final reason = reasons.removeAt(index);
          final category = categories.removeAt(index);

          destinations.insert(0, city);
          reasons.insert(0, reason);
          categories.insert(0, category);
        }
      }

      print('Final destinations: $destinations');
      print('Final reasons: $reasons');

      return TravelRecommendation(
        destinations: destinations, // take(3) 제거
        reasons: reasons, // take(3) 제거
        tips: [],
        preferredCities: preferredCities,
      );
    } catch (e) {
      print('Error parsing Gemini response: $e');
      throw Exception('Failed to parse travel recommendations: $e');
    }
  }

  get otherDestinations => null;
}
