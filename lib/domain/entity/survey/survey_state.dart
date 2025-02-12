class SurveyState {
  final String? travelPeriod;
  final String? travelDuration;
  final String? companion;
  final String? travelStyle;
  final String? accommodationType;
  final String? consideration;
  final List<String> selectedCities;
  final int currentPage;

  SurveyState({
    this.travelPeriod,
    this.travelDuration,
    this.companion,
    this.travelStyle,
    this.accommodationType,
    this.consideration,
    this.selectedCities = const [],
    this.currentPage = 0,
  });

  SurveyState copyWith({
    String? travelPeriod,
    String? travelDuration,
    String? companion,
    String? travelStyle,
    String? accommodationType,
    String? consideration,
    List<String>? selectedCities,
    int? currentPage,
  }) {
    return SurveyState(
      travelPeriod: travelPeriod ?? this.travelPeriod,
      travelDuration: travelDuration ?? this.travelDuration,
      companion: companion ?? this.companion,
      travelStyle: travelStyle ?? this.travelStyle,
      accommodationType: accommodationType ?? this.accommodationType,
      consideration: consideration ?? this.consideration,
      selectedCities: selectedCities ?? this.selectedCities,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}
