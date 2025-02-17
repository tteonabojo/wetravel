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

    try {
      final sections = response.split('---');
      print('Number of sections: ${sections.length}');

      // 각 섹션에서 도시와 이유 추출
      for (var section in sections) {
        if (section.trim().isEmpty) continue;

        final cityMatch = RegExp(r'도시명:\s*([^*\n]+)').firstMatch(section);
        final reasonMatch = RegExp(r'추천 이유:\s*([^*\n]+)').firstMatch(section);

        if (cityMatch != null && reasonMatch != null) {
          final city = cityMatch.group(1)?.trim() ?? '';
          final reason = reasonMatch.group(1)?.trim() ?? '';

          if (city.isNotEmpty && reason.isNotEmpty) {
            destinations.add(city);
            reasons.add(reason);
          }
        }
      }

      // 선호 도시가 있는 경우, 해당 도시를 첫 번째로 이동
      if (preferredCities.isNotEmpty) {
        final preferredCity = preferredCities[0];
        final index = destinations.indexWhere(
          (d) => d.toLowerCase().contains(preferredCity.toLowerCase()),
        );

        if (index != -1 && index != 0) {
          // 도시와 이유를 함께 이동
          final city = destinations.removeAt(index);
          final reason = reasons.removeAt(index);
          destinations.insert(0, city);
          reasons.insert(0, reason);
        }
      }

      return TravelRecommendation(
        destinations: destinations,
        reasons: reasons,
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
