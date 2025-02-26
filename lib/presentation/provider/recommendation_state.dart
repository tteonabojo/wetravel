class RecommendationState {
  final bool isLoading;
  final List<String> destinations;
  final List<String> reasons;
  final String? selectedDestination;
  final String? error;

  const RecommendationState({
    this.isLoading = true,
    this.destinations = const [],
    this.reasons = const [],
    this.selectedDestination,
    this.error,
  });

  RecommendationState copyWith({
    bool? isLoading,
    List<String>? destinations,
    List<String>? reasons,
    String? selectedDestination,
    String? error,
  }) {
    return RecommendationState(
      isLoading: isLoading ?? this.isLoading,
      destinations: destinations ?? this.destinations,
      reasons: reasons ?? this.reasons,
      selectedDestination: selectedDestination ?? this.selectedDestination,
      error: error ?? this.error,
    );
  }
}
