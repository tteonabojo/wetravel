import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/domain/entity/survey_response.dart';

final surveyProvider =
    StateNotifierProvider<SurveyNotifier, SurveyResponse>((ref) {
  return SurveyNotifier();
});

class SurveyNotifier extends StateNotifier<SurveyResponse> {
  SurveyNotifier()
      : super(SurveyResponse(
            travelPeriod: '',
            travelDuration: '',
            companions: [],
            travelStyles: [],
            accommodationTypes: [],
            considerations: []));

  void updateTravelPeriod(String period) {
    state = state.copyWith(travelPeriod: period);
  }

  void updateTravelDuration(String duration) {
    state = state.copyWith(travelDuration: duration);
  }

  void updateCompanions(List<String> companions) {
    state = state.copyWith(companions: companions);
  }

  void updateTravelStyles(List<String> styles) {
    state = state.copyWith(travelStyles: styles);
  }

  void updateAccommodationTypes(List<String> types) {
    state = state.copyWith(accommodationTypes: types);
  }

  void updateConsiderations(List<String> considerations) {
    state = state.copyWith(considerations: considerations);
  }
}
