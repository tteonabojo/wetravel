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
    dev.log('Parsing Gemini response: $response');
    dev.log('Preferred cities: $preferredCities');

    try {
      List<String> finalDestinations = [];
      List<String> finalReasons = [];
      List<String> finalTips = [];
      List<String> parsedDestinations = [];

      if (preferredCities.isNotEmpty) {
        finalDestinations = [...preferredCities];
        dev.log('Set final destinations: $finalDestinations');

        final lines = response.split('\n');
        final Map<String, String> reasonsMap = {};
        final Map<String, String> tipsMap = {};
        String currentDestination = '';

        for (var line in lines) {
          line = line.trim();
          if (line.isEmpty) continue;

          line = line.replaceAll('**', '').replaceAll('*', '');
          dev.log('Processing line: $line');

          final cityPattern = RegExp(r'^\d+\.\s*(.+?)(?:\s*\(.*\)|$)');
          final cityMatch = cityPattern.firstMatch(line);
          if (cityMatch != null) {
            currentDestination = cityMatch.group(1)?.trim() ?? '';
            if (currentDestination.isNotEmpty) {
              parsedDestinations.add(currentDestination);
              dev.log('Found destination: $currentDestination');
            }
            continue;
          }

          if (currentDestination.isEmpty) continue;

          if (line.startsWith('-') || line.startsWith('•')) {
            final content = line.substring(1).trim().toLowerCase();
            dev.log('Processing content: $content');

            if (content.contains('추천 이유:') || content.contains('이유:')) {
              final reason = content.split(':')[1].trim();
              reasonsMap[currentDestination.toLowerCase()] = reason;
              dev.log(
                  'Added reason for ${currentDestination.toLowerCase()}: $reason');
            } else if (content.contains('주의사항/팁:') ||
                content.contains('주의사항:') ||
                content.contains('팁:')) {
              final tip = content.split(':')[1].trim();
              tipsMap[currentDestination.toLowerCase()] = tip;
              dev.log(
                  'Added tip for ${currentDestination.toLowerCase()}: $tip');
            }
          }
        }

        dev.log('Final reasonsMap: $reasonsMap');
        dev.log(
            'Cities to find reasons for: ${finalDestinations.map((c) => c.toLowerCase())}');

        finalReasons = finalDestinations.map((city) {
          final lowerCity = city.toLowerCase();
          if (!reasonsMap.containsKey(lowerCity)) {
            dev.log('Missing reason for city: $lowerCity');
            throw Exception('도시 추천 이유를 찾을 수 없습니다: $city');
          }
          return reasonsMap[lowerCity]!;
        }).toList();

        finalTips = finalDestinations.map((city) {
          return tipsMap[city.toLowerCase()] ?? '주의사항이 없습니다.';
        }).toList();
      } else {
        final List<String> destinations = [];
        final Map<String, String> reasonsMap = {};
        final Map<String, String> tipsMap = {};

        final lines = response.split('\n');
        String currentDestination = '';

        for (var line in lines) {
          line = line.trim();
          if (line.isEmpty) continue;

          line = line.replaceAll('**', '').replaceAll('*', '');

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

        if (destinations.isEmpty || reasonsMap.isEmpty) {
          throw Exception('응답을 파싱할 수 없습니다.');
        }

        finalReasons = destinations.map((d) => reasonsMap[d] ?? '').toList();
        finalTips =
            destinations.map((d) => tipsMap[d] ?? '주의사항이 없습니다.').toList();

        finalDestinations = destinations;
      }

      dev.log('Parsed destinations: $finalDestinations');
      dev.log('Parsed reasons: $finalReasons');
      dev.log('Parsed tips: $finalTips');

      return TravelRecommendation(
        destinations: finalDestinations,
        reasons: finalReasons,
        tips: finalTips,
        preferredCities: preferredCities,
      );
    } catch (e) {
      dev.log('Error parsing Gemini response: $e');
      throw Exception('응답을 파싱할 수 없습니다.');
    }
  }

  get otherDestinations => null;
}
