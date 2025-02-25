import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:wetravel/domain/entity/survey_response.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
      model: 'gemini-1.5-pro',
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topK: 40,
        topP: 0.95,
      ),
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
    // 도시 카테고리 정보 추가
    final cityCategories = '''
도시 카테고리 정보:
- 일본: 도쿄, 오사카, 교토, 나라, 후쿠오카, 삿포로
- 한국: 서울, 부산, 제주, 강릉, 여수, 경주
- 동남아시아: 방콕, 싱가포르, 발리, 세부, 다낭, 하노이
- 미국: 뉴욕, 로스앤젤레스, 샌프란시스코, 라스베가스, 하와이
- 유럽: 파리, 런던, 로마, 바르셀로나, 암스테르담, 프라하, 베니스
''';

    final prompt = '''
다음 여행 선호도를 바탕으로 전세계의 여행지를 추천해주세요.

여행 정보:
- 여행 시기: ${surveyResponse.travelPeriod}
- 여행 기간: ${surveyResponse.travelDuration}
- 동행인: ${surveyResponse.companions.join(', ')}
- 여행 스타일: ${surveyResponse.travelStyles.join(', ')}
- 숙소 타입: ${surveyResponse.accommodationTypes.join(', ')}
- 고려사항: ${surveyResponse.considerations.join(', ')}

$cityCategories

${preferredCities != null && preferredCities.isNotEmpty ? '''
[중요] 사용자가 선택한 도시: ${preferredCities.first}
이 도시는 반드시 첫 번째 추천 도시여야 합니다.
두 번째와 세 번째 추천 도시는 첫 번째 도시와 같은 카테고리에 속한 도시여야 합니다.
예를 들어, 사용자가 "도쿄"를 선택했다면 2,3순위는 "오사카", "교토" 등 일본의 다른 도시여야 합니다.

반드시 아래 형식으로 정확히 3개의 도시를 추천해주세요.
각 도시 추천 사이에는 반드시 "---" 구분자를 넣어주세요:

첫 번째 도시 (사용자가 선택한 도시):
도시명: ${preferredCities.first}
추천 이유: [사용자의 여행 선호도와 스타일을 반영한 이유]
---
두 번째 도시 (같은 카테고리의 다른 도시):
도시명: [도시명]
추천 이유: [사용자의 여행 선호도와 스타일을 반영한 이유]
---
세 번째 도시 (같은 카테고리의 또 다른 도시):
도시명: [도시명]
추천 이유: [사용자의 여행 선호도와 스타일을 반영한 이유]
''' : '''
[중요] 사용자가 선택한 도시가 없으므로, 서로 다른 카테고리에서 3개의 도시를 추천해주세요.
예를 들어, 일본의 도시 1개, 유럽의 도시 1개, 동남아시아의 도시 1개와 같이 다양한 지역에서 추천해주세요.

반드시 아래 형식으로 서로 다른 카테고리의 도시 3개를 추천해주세요.
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
   - 2,3순위는 첫 번째 도시와 같은 카테고리의 도시로 추천 (위 카테고리 정보 참조)
2. 선택된 도시가 없는 경우:
   - 서로 다른 카테고리에서 3개의 도시를 추천 (다양성 확보)
3. 각 도시 추천은 반드시 "---" 구분자로 구분
4. 정확히 3개의 도시를 추천
5. 각 도시는 "도시명:"과 "추천 이유:" 형식을 준수
''';

    final apiKey = dotenv.env['GEMINI_API_KEY'];

    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent?key=$apiKey');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'topK': 40,
            'topP': 0.95,
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates'][0]['content']['parts'][0]['text'];
        return text;
      } else {
        throw Exception(
            'Failed to get travel recommendations: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to get travel recommendations: $e');
    }
  }

  /// 여행 일정 생성 요청
  /// [survey]: 사용자의 설문 응답
  Future<String> getTravelSchedule(SurveyResponse survey) async {
    final prompt = _buildSchedulePrompt(survey);

    final apiKey = dotenv.env['GEMINI_API_KEY'];
    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent?key=$apiKey');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'topK': 40,
            'topP': 0.95,
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates'][0]['content']['parts'][0]['text'];
        return text;
      } else {
        throw Exception('Failed to get travel schedule: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to get travel schedule: $e');
    }
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
