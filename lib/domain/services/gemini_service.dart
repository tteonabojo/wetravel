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
    if (kDebugMode) {
      print('[log] Gemini model initialized with API key');
    }
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
${preferredCities != null && preferredCities.isNotEmpty ? '''
선호하는 도시: ${preferredCities.join(', ')}

반드시 아래 순서와 형식으로 정확히 3개의 도시를 추천해주세요:

첫 번째 도시:
도시명: ${preferredCities.first}
카테고리: [도시의 주요 특징]
추천 이유: [사용자의 여행 선호도와 스타일을 반영한 이유]
---
두 번째 도시:
도시명: [도시명], [국가명]
카테고리: [첫 번째 도시와 동일한 카테고리]
추천 이유: [사용자의 여행 선호도와 스타일을 반영한 이유]
---
세 번째 도시:
도시명: [도시명], [국가명]
카테고리: [첫 번째 도시와 동일한 카테고리]
추천 이유: [사용자의 여행 선호도와 스타일을 반영한 이유]
''' : '''
반드시 아래 형식으로 3개의 도시를 추천해주세요:

첫 번째 도시:
도시명: [도시명], [국가명]
카테고리: [도시의 주요 특징]
추천 이유: [사용자의 여행 선호도와 스타일을 반영한 이유]
---
두 번째 도시:
도시명: [도시명], [국가명]
카테고리: [첫 번째 도시와 동일한 카테고리]
추천 이유: [사용자의 여행 선호도와 스타일을 반영한 이유]
---
세 번째 도시:
도시명: [도시명], [국가명]
카테고리: [첫 번째 도시와 동일한 카테고리]
추천 이유: [사용자의 여행 선호도와 스타일을 반영한 이유]
'''}

여행 정보:
- 여행 시기: ${surveyResponse.travelPeriod}
- 여행 기간: ${surveyResponse.travelDuration}
- 동행인: ${surveyResponse.companions.join(', ')}
- 여행 스타일: ${surveyResponse.travelStyles.join(', ')}
- 숙소 타입: ${surveyResponse.accommodationTypes.join(', ')}
- 고려사항: ${surveyResponse.considerations.join(', ')}

주의사항:
1. 반드시 위 형식을 정확히 지켜주세요.
2. 정확히 3개의 도시를 추천해야 합니다.
3. 각 도시는 "도시명: [도시명], [국가명]" 형식으로 작성해주세요.
4. 각 도시 추천 사이에는 반드시 "---" 구분자를 넣어주세요.
5. 추천 이유는 여행자의 선호도를 구체적으로 반영해주세요.
6. 선호 도시가 있는 경우, 반드시 첫 번째로 추천하고 나머지는 같은 카테고리의 도시를 추천해주세요.
''';

    try {
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      if (response.text == null) {
        throw Exception('Gemini returned null response');
      }
      print('Gemini Response: ${response.text}');
      return response.text!;
    } catch (e) {
      print('Error in getTravelRecommendation: $e');
      throw Exception('Failed to get travel recommendations: $e');
    }
  }

  /// 여행지 추천을 위한 프롬프트 생성
  /// [survey]: 사용자의 설문 응답
  /// [preferredCities]: 선호하는 도시 목록 (선택 사항)
  String _buildRecommendationPrompt(
    SurveyResponse survey, {
    List<String>? preferredCities,
  }) {
    final buffer = StringBuffer();

    // 기본 지시사항
    buffer.writeln('다음 여행 정보를 바탕으로 여행지를 추천해주세요.');
    buffer.writeln('아래 형식을 정확히 지켜서 답변해주세요.');

    // 선호 도시가 있는 경우 추가 지시사항
    if (preferredCities != null && preferredCities.isNotEmpty) {
      buffer.writeln('\n선택된 도시:');
      buffer.writeln('- ${preferredCities.first}');
      buffer.writeln('\n추가 추천할 도시들:');
      for (var city in preferredCities.skip(1)) {
        buffer.writeln('- $city');
      }
      buffer.writeln('\n위 도시들을 반드시 포함하여 추천해주세요.');
      buffer.writeln('선택된 도시를 1순위로 하고, 추천 도시들을 2, 3순위로 배치해주세요.');
      buffer.writeln('각 도시에 대해 여행 정보를 바탕으로 한 추천 이유와 주의사항을 작성해주세요.');
    }

    // 여행 정보 추가
    buffer.writeln('\n여행 정보:');
    buffer.writeln('- 여행 시기: ${survey.travelPeriod}');
    buffer.writeln('- 여행 기간: ${survey.travelDuration}');
    buffer.writeln('- 동행인: ${survey.companions.join(", ")}');
    buffer.writeln('- 여행 스타일: ${survey.travelStyles.join(", ")}');
    buffer.writeln('- 선호하는 숙소: ${survey.accommodationTypes.join(", ")}');
    buffer.writeln('- 고려사항: ${survey.considerations.join(", ")}');

    // 답변 형식 지정
    buffer.writeln('\n답변 형식:');
    buffer.writeln('1. 도시이름 (국가)');
    buffer.writeln('- 추천 이유: 이유를 여기에 작성');
    buffer.writeln('- 주의사항/팁: 주의사항을 여기에 작성');

    // 추가 지시사항
    buffer.writeln('\n위 형식으로 3개 도시를 추천해주세요.');
    buffer.writeln('추천 시 계절, 여행 기간, 동행인, 여행 스타일을 고려해서 적합한 도시를 추천해주세요.');
    if (preferredCities != null && preferredCities.isNotEmpty) {
      buffer.writeln('반드시 선택된 도시를 1순위로 배치하고, 나머지 추천 도시들을 포함해주세요.');
    }

    return buffer.toString();
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
