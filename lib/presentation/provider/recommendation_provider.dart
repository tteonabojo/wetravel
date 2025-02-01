import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/domain/entity/survey_response.dart';
import 'package:wetravel/domain/entity/travel_recommendation.dart';
import 'package:wetravel/domain/services/gemini_service.dart';

final geminiServiceProvider = Provider((ref) => GeminiService());

final recommendationProvider = FutureProvider.autoDispose
    .family<TravelRecommendation, SurveyResponse>((ref, survey) async {
  final geminiService = ref.read(geminiServiceProvider);
  final response = await geminiService.getTravelRecommendation(survey);
  return TravelRecommendation.fromGeminiResponse(response);
});
