import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:wetravel/domain/entity/survey_response.dart';
import 'package:flutter/foundation.dart';

/// Gemini AI 서비스를 관리하는 클래스
class GeminiService {
  late final GenerativeModel model;

  /// Gemini API 초기화 및 모델 설정
  GeminiService() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null) {
      throw Exception('GEMINI_API_KEY not found in environment variables');
    }
    model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: apiKey,
    );
    if (kDebugMode) {}
  }

  /// 여행지 추천 요청
  /// [survey]: 사용자의 설문 응답
  /// [preferredCities]: 선호하는 도시 목록 (선택 사항)
  Future<String> getTravelRecommendation(
    SurveyResponse surveyResponse, {
    List<String>? preferredCities,
  }) async {
    final prompt = '''
다음 여행 선호도를 바탕으로 전세계의 여행지를 추천해주세요.

여행 정보:
- 여행 시기: ${surveyResponse.travelPeriod}
- 여행 기간: ${surveyResponse.travelDuration}
- 동행인: ${surveyResponse.companions.join(', ')}
- 여행 스타일: ${surveyResponse.travelStyles.join(', ')}
- 숙소 타입: ${surveyResponse.accommodationTypes.join(', ')}
- 고려사항: ${surveyResponse.considerations.join(', ')}

${preferredCities != null && preferredCities.isNotEmpty ? '''
[중요] 사용자가 선택한 도시: ${preferredCities.first}
이 도시는 반드시 첫 번째 추천 도시여야 하며, 두 번째와 세 번째 추천 도시는 같은 국가/지역의 도시여야 합니다.

예시:
- 사용자가 "도쿄"를 선택한 경우: 도쿄(1순위) -> 오사카, 교토(2,3순위)
- 사용자가 "파리"를 선택한 경우: 파리(1순위) -> 니스, 마르세유(2,3순위)

반드시 아래 형식으로 정확히 3개의 도시를 추천해주세요.
각 도시 추천 사이에는 반드시 "---" 구분자를 넣어주세요:

첫 번째 도시 (사용자가 선택한 도시):
도시명: ${preferredCities.first}
추천 이유: [사용자의 여행 선호도와 스타일을 반영한 이유]
---
두 번째 도시 (추가 추천):
도시명: [도시명]
추천 이유: [사용자의 여행 선호도와 스타일을 반영한 이유]
---
세 번째 도시 (추가 추천):
도시명: [도시명]
추천 이유: [사용자의 여행 선호도와 스타일을 반영한 이유]
''' : '''
반드시 아래 형식으로 정확히 3개의 도시를 추천해주세요.
각 도시 추천 사이에는 반드시 "---" 구분자를 넣어주세요:

첫 번째 도시:
도시명: [도시명]
추천 이유: [사용자의 여행 선호도와 스타일을 반영한 이유]
---
두 번째 도시:
도시명: [도시명]
추천 이유: [사용자의 여행 선호도와 스타일을 반영한 이유]
---
세 번째 도시:
도시명: [도시명]
추천 이유: [사용자의 여행 선호도와 스타일을 반영한 이유]
'''}

[중요 지시사항]
1. 선택된 도시가 있는 경우:
   - 반드시 첫 번째 도시로 추천
   - 2,3순위는 같은 국가/지역의 도시로 추천
2. 각 도시 추천은 반드시 "---" 구분자로 구분
3. 정확히 3개의 도시를 추천
4. 각 도시는 "도시명:"과 "추천 이유:" 형식을 준수
''';

    try {
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      if (response.text == null) {
        throw Exception('Gemini returned null response');
      }
      return response.text!;
    } catch (e) {
      throw Exception('Failed to get travel recommendations: $e');
    }
  }

  /// 여행 일정 생성 요청
  /// [survey]: 사용자의 설문 응답
  Future<String> getTravelSchedule(SurveyResponse survey) async {
    final prompt = _buildSchedulePrompt(survey);
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);
    return response.text!;
  }

  /// 여행 일정을 위한 프롬프트 생성
  /// [survey]: 사용자의 설문 응답
  String _buildSchedulePrompt(SurveyResponse survey) {
    return '''
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
  }
}
