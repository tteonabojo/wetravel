import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/domain/entity/survey_response.dart';
import 'package:wetravel/domain/entity/travel_recommendation.dart';
import 'package:wetravel/domain/services/gemini_service.dart';
import 'package:wetravel/presentation/provider/recommendation_state.dart';

class RecommendationNotifier extends StateNotifier<RecommendationState> {
  final GeminiService _geminiService;

  RecommendationNotifier({
    required GeminiService geminiService,
  })  : _geminiService = geminiService,
        super(const RecommendationState());

  Future<void> loadRecommendations(SurveyResponse survey) async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await _geminiService.getTravelRecommendation(survey);
      final recommendation = TravelRecommendation.fromGeminiResponse(response);
      state = state.copyWith(
        destinations: recommendation.destinations,
        reasons: recommendation.reasons,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  void selectDestination(String destination) {
    state = state.copyWith(selectedDestination: destination);
  }
}
