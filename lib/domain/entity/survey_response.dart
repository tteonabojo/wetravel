import 'package:wetravel/domain/entity/survey/survey_state.dart';
import 'package:wetravel/domain/entity/travel_schedule.dart';

class SurveyResponse {
  final String travelPeriod;
  final String travelDuration;
  final List<String> companions;
  final List<String> travelStyles;
  final List<String> accommodationTypes;
  final List<String> considerations;
  final String? selectedCity; // nullable로 변경
  final TravelSchedule? savedSchedule; // 저장된 일정 필드 추가

  SurveyResponse({
    required this.travelPeriod,
    required this.travelDuration,
    required this.companions,
    required this.travelStyles,
    required this.accommodationTypes,
    required this.considerations,
    this.selectedCity, // optional로 변경
    this.savedSchedule, // 생성자에 savedSchedule 추가
  });

  SurveyResponse copyWith({
    String? travelPeriod,
    String? travelDuration,
    List<String>? companions,
    List<String>? travelStyles,
    List<String>? accommodationTypes,
    List<String>? considerations,
    String? selectedCity,
    TravelSchedule? savedSchedule,
  }) {
    return SurveyResponse(
      travelPeriod: travelPeriod ?? this.travelPeriod,
      travelDuration: travelDuration ?? this.travelDuration,
      companions: companions ?? this.companions,
      travelStyles: travelStyles ?? this.travelStyles,
      accommodationTypes: accommodationTypes ?? this.accommodationTypes,
      considerations: considerations ?? this.considerations,
      selectedCity: selectedCity ?? this.selectedCity,
      savedSchedule: savedSchedule ?? this.savedSchedule,
    );
  }

  // fromState 메서드 수정
  factory SurveyResponse.fromState(SurveyState state) {
    return SurveyResponse(
      travelPeriod: state.travelPeriod ?? '',
      travelDuration: state.travelDuration ?? '',
      companions: [if (state.companion != null) state.companion!],
      travelStyles: [if (state.travelStyle != null) state.travelStyle!],
      accommodationTypes: [
        if (state.accommodationType != null) state.accommodationType!
      ],
      considerations: [if (state.consideration != null) state.consideration!],
      selectedCity:
          state.selectedCities.isNotEmpty ? state.selectedCities.first : null,
      savedSchedule: null,
    );
  }
}
