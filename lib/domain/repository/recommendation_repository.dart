import 'package:wetravel/domain/entity/survey_response.dart';
import 'package:wetravel/domain/entity/travel_recommendation.dart';

abstract class RecommendationRepository {
  Future<TravelRecommendation> getRecommendation(SurveyResponse survey);
}
