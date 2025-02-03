class SurveyResponse {
  final String travelPeriod; // 여행시기
  final String travelDuration; // 여행기간
  final List<String> companions; // 동행인원
  final List<String> travelStyles; // 여행스타일
  final List<String> accommodationTypes; // 숙소스타일
  final List<String> considerations; // 기타 고려사항
  final String? selectedCity; // 추가

  SurveyResponse({
    required this.travelPeriod,
    required this.travelDuration,
    required this.companions,
    required this.travelStyles,
    required this.accommodationTypes,
    required this.considerations,
    this.selectedCity, // 선택적 파라미터로 추가
  });

  SurveyResponse copyWith({
    String? travelPeriod,
    String? travelDuration,
    List<String>? companions,
    List<String>? travelStyles,
    List<String>? accommodationTypes,
    List<String>? considerations,
    String? selectedCity,
  }) {
    return SurveyResponse(
      travelPeriod: travelPeriod ?? this.travelPeriod,
      travelDuration: travelDuration ?? this.travelDuration,
      companions: companions ?? this.companions,
      travelStyles: travelStyles ?? this.travelStyles,
      accommodationTypes: accommodationTypes ?? this.accommodationTypes,
      considerations: considerations ?? this.considerations,
      selectedCity: selectedCity ?? this.selectedCity,
    );
  }
}
