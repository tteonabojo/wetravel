import 'package:wetravel/domain/entity/survey_response.dart';
import 'package:wetravel/domain/entity/travel_recommendation.dart';
import 'package:wetravel/domain/repository/recommendation_repository.dart';
import 'package:wetravel/domain/services/gemini_service.dart';

class RecommendationRepositoryImpl implements RecommendationRepository {
  final GeminiService _geminiService;

  RecommendationRepositoryImpl(this._geminiService);

  @override
  Future<TravelRecommendation> getRecommendation(SurveyResponse survey) async {
    final response = await _geminiService.getTravelRecommendation(survey);
    return TravelRecommendation.fromGeminiResponse(response);
  }
}
