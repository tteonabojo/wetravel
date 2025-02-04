import 'dart:developer' as dev;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:wetravel/domain/entity/survey_response.dart';

class GeminiService {
  late final GenerativeModel model;

  GeminiService() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null) {
      throw Exception('GEMINI_API_KEY not found in environment variables');
    }
    model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: apiKey,
    );
    dev.log('Gemini model initialized with API key');
  }

  Future<String> getTravelRecommendation(SurveyResponse survey) async {
    try {
      final prompt = _buildPrompt(survey);
      dev.log('Sending prompt to Gemini: $prompt');

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      if (response.text == null) {
        throw Exception('Gemini returned null response');
      }

      dev.log('Received response from Gemini: ${response.text}');
      return response.text!;
    } catch (e, stackTrace) {
      dev.log('Error in Gemini service: $e\n$stackTrace');
      rethrow;
    }
  }

  String _buildPrompt(SurveyResponse survey) {
    dev.log('Selected city: ${survey.selectedCity}');

    // 도시 카테고리 매핑
    const cityCategories = {
      '일본': ['도쿄', '오사카', '시즈오카', '나고야', '삿포로', '후쿠오카', '교토', '나라'],
      '한국': ['서울', '부산', '제주', '강릉', '여수', '경주'],
      '동남아시아': ['방콕', '싱가포르', '발리', '세부', '다낭', '하노이', '호치민', '쿠알라룸푸르'],
      '미국': ['뉴욕', '로스앤젤레스', '샌프란시스코', '라스베가스', '시애틀', '하와이'],
      '유럽': ['파리', '런던', '로마', '바르셀로나', '암스테르담', '프라하', '비엔나', '베니스'],
    };

    // 선택된 도시의 카테고리와 추천할 도시들 찾기
    String? selectedCategory;
    List<String> recommendedCities = [];
    if (survey.selectedCity != null) {
      for (var entry in cityCategories.entries) {
        if (entry.value.contains(survey.selectedCity)) {
          selectedCategory = entry.key;
          // 같은 카테고리에서 선택된 도시를 제외한 다른 도시들 중 2개 선택
          recommendedCities = entry.value
              .where((city) => city != survey.selectedCity)
              .take(2)
              .toList();
          break;
        }
      }
    }

    final prompt = '''
여행 추천을 해주세요. 다음 조건을 고려해주세요:

${survey.selectedCity != null ? '- 선택된 도시: ${survey.selectedCity}' : ''}
- 여행 기간: ${survey.travelPeriod}
- 체류 기간: ${survey.travelDuration}
- 동행: ${survey.companions.join(', ')}
- 여행 스타일: ${survey.travelStyles.join(', ')}
- 숙소 타입: ${survey.accommodationTypes.join(', ')}
- 고려사항: ${survey.considerations.join(', ')}

아래 세 도시에 대해서만 추천해주세요.
정확히 아래 형식을 지켜주세요:
${survey.selectedCity != null ? '''
1. ${survey.selectedCity} - 추천 이유: [이유] / 주의사항/팁: [팁]
2. ${recommendedCities[0]} - 추천 이유: [이유] / 주의사항/팁: [팁]
3. ${recommendedCities[1]} - 추천 이유: [이유] / 주의사항/팁: [팁]
''' : '''
1. [도시명] - 추천 이유: [이유] / 주의사항/팁: [팁]
2. [도시명] - 추천 이유: [이유] / 주의사항/팁: [팁]
3. [도시명] - 추천 이유: [이유] / 주의사항/팁: [팁]
'''}

반드시 위 형식을 정확히 지켜주세요.
추천 이유와 주의사항은 슬래시(/)로 구분해주세요.
각 도시는 한 줄로 작성해주세요.
''';
    return prompt;
  }

  Future<String> getTravelSchedule(SurveyResponse survey) async {
    final prompt = '''
여행 정보:
- 도시: ${survey.selectedCity}
- 여행 기간: ${survey.travelDuration}
- 동행인: ${survey.companions.join(', ')}
- 여행 스타일: ${survey.travelStyles.join(', ')}
- 숙소 유형: ${survey.accommodationTypes.join(', ')}
- 고려사항: ${survey.considerations.join(', ')}

위 정보를 바탕으로 상세한 일정을 만들어주세요.
각 일정은 다음과 같은 형식으로 작성해주세요:

Day 1
09:00 - [활동 내용] @ [장소]
11:00 - [활동 내용] @ [장소]
...

응답은 위 형식만 포함해야 합니다.
''';

    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);
    return response.text!;
  }
}
