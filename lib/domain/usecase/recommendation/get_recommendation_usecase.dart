import 'package:wetravel/domain/entity/survey_response.dart';
import 'package:wetravel/domain/entity/travel_recommendation.dart';
import 'package:wetravel/domain/repository/recommendation_repository.dart';

class GetRecommendationUseCase {
  final RecommendationRepository _repository;

  GetRecommendationUseCase(this._repository);

  Future<TravelRecommendation> execute(SurveyResponse survey) {
    return _repository.getRecommendation(survey);
  }
}
