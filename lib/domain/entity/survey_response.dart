class SurveyResponse {
  final String? travelTiming; // 여행시기
  final String? travelDuration; // 여행기간
  final String? companion; // 동행인원
  final String? travelStyle; // 여행스타일
  final String? accommodation; // 숙소스타일
  final String? concerns; // 기타 고려사항

  SurveyResponse({
    this.travelTiming,
    this.travelDuration,
    this.companion,
    this.travelStyle,
    this.accommodation,
    this.concerns,
  });

  SurveyResponse copyWith({
    String? travelTiming,
    String? travelDuration,
    String? companion,
    String? travelStyle,
    String? accommodation,
    String? concerns,
  }) {
    return SurveyResponse(
      travelTiming: travelTiming ?? this.travelTiming,
      travelDuration: travelDuration ?? this.travelDuration,
      companion: companion ?? this.companion,
      travelStyle: travelStyle ?? this.travelStyle,
      accommodation: accommodation ?? this.accommodation,
      concerns: concerns ?? this.concerns,
    );
  }
}
