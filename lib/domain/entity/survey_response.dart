import 'package:wetravel/domain/entity/travel_schedule.dart';

class SurveyResponse {
  final String? selectedCity; // null 허용으로 변경
  final String travelPeriod; // 여행시기
  final String travelDuration; // 여행기간
  final List<String> companions; // 동행인원
  final List<String> travelStyles; // 여행스타일
  final List<String> accommodationTypes; // 숙소스타일
  final List<String> considerations; // 기타 고려사항
  final TravelSchedule? savedSchedule; // 저장된 일정 필드 추가

  SurveyResponse({
    this.selectedCity, // required 제거
    required this.travelPeriod,
    required this.travelDuration,
    required this.companions,
    required this.travelStyles,
    required this.accommodationTypes,
    required this.considerations,
    this.savedSchedule, // 생성자에 savedSchedule 추가
  });

  SurveyResponse copyWith({
    String? selectedCity,
    String? travelPeriod,
    String? travelDuration,
    List<String>? companions,
    List<String>? travelStyles,
    List<String>? accommodationTypes,
    List<String>? considerations,
    TravelSchedule? savedSchedule,
  }) {
    return SurveyResponse(
      selectedCity: selectedCity ?? this.selectedCity,
      travelPeriod: travelPeriod ?? this.travelPeriod,
      travelDuration: travelDuration ?? this.travelDuration,
      companions: companions ?? this.companions,
      travelStyles: travelStyles ?? this.travelStyles,
      accommodationTypes: accommodationTypes ?? this.accommodationTypes,
      considerations: considerations ?? this.considerations,
      savedSchedule: savedSchedule ?? this.savedSchedule,
    );
  }
}
