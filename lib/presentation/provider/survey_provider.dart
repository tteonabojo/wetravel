import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/domain/entity/survey_response.dart';

final surveyProvider =
    StateNotifierProvider<SurveyNotifier, SurveyResponse>((ref) {
  return SurveyNotifier();
});

class SurveyNotifier extends StateNotifier<SurveyResponse> {
  SurveyNotifier() : super(SurveyResponse());

  void updateTravelTiming(String timing) {
    state = state.copyWith(travelTiming: timing);
  }

  void updateTravelDuration(String duration) {
    state = state.copyWith(travelDuration: duration);
  }

  void updateCompanion(String companion) {
    state = state.copyWith(companion: companion);
  }

  void updateTravelStyle(String style) {
    state = state.copyWith(travelStyle: style);
  }

  void updateAccommodation(String accommodation) {
    state = state.copyWith(accommodation: accommodation);
  }

  void updateConcerns(String concerns) {
    state = state.copyWith(concerns: concerns);
  }
}
