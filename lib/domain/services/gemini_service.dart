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
    return '''
다음 여행 정보를 바탕으로 전 세계 여행지 3곳을 추천해주세요.
아래 형식을 정확히 지켜서 답변해주세요.

여행 정보:
- 여행 시기: ${survey.travelPeriod}
- 여행 기간: ${survey.travelDuration}
- 동행인: ${survey.companions}
- 여행 스타일: ${survey.travelStyles}
- 선호하는 숙소: ${survey.accommodationTypes}
- 고려사항: ${survey.considerations}

답변 형식:
1. 도시이름 (국가)
- 추천 이유: 이유를 여기에 작성
- 주의사항/팁: 주의사항을 여기에 작성

위 형식으로 3개 도시를 추천해주세요.
추천 시 계절, 여행 기간, 동행인, 여행 스타일을 고려해서 적합한 도시를 추천해주세요.
''';
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
