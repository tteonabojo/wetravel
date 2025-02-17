class SurveyResponse {
  final String? selectedCity; // null 허용으로 변경
  final String travelPeriod; // 여행시기
  final String travelDuration; // 여행기간
  final List<String> companions; // 동행인원
  final List<String> travelStyles; // 여행스타일
  final List<String> accommodationTypes; // 숙소스타일
  final List<String> considerations; // 기타 고려사항

  SurveyResponse({
    this.selectedCity, // required 제거
    required this.travelPeriod,
    required this.travelDuration,
    required this.companions,
    required this.travelStyles,
    required this.accommodationTypes,
    required this.considerations,
  });

  SurveyResponse copyWith({
    String? selectedCity,
    String? travelPeriod,
    String? travelDuration,
    List<String>? companions,
    List<String>? travelStyles,
    List<String>? accommodationTypes,
    List<String>? considerations,
  }) {
    return SurveyResponse(
      selectedCity: selectedCity ?? this.selectedCity,
      travelPeriod: travelPeriod ?? this.travelPeriod,
      travelDuration: travelDuration ?? this.travelDuration,
      companions: companions ?? this.companions,
      travelStyles: travelStyles ?? this.travelStyles,
      accommodationTypes: accommodationTypes ?? this.accommodationTypes,
      considerations: considerations ?? this.considerations,
    );
  }
}
