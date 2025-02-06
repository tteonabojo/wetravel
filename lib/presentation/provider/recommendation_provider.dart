import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/domain/entity/survey_response.dart';
import 'package:wetravel/domain/entity/travel_recommendation.dart';
import 'package:wetravel/domain/services/gemini_service.dart';

final geminiServiceProvider = Provider((ref) => GeminiService());

class RecommendationState {
  final int currentPage;
  final String? travelPeriod;
  final String? travelDuration;
  final List<String> companions;
  final List<String> travelStyles;
  final List<String> accommodationTypes;
  final List<String> considerations;
  final List<String> selectedCities;
  final List<String> selectedKeywords;

  RecommendationState({
    this.currentPage = 0,
    this.travelPeriod,
    this.travelDuration,
    this.companions = const [],
    this.travelStyles = const [],
    this.accommodationTypes = const [],
    this.considerations = const [],
    this.selectedCities = const [],
    this.selectedKeywords = const [],
  });

  RecommendationState copyWith({
    int? currentPage,
    String? travelPeriod,
    String? travelDuration,
    List<String>? companions,
    List<String>? travelStyles,
    List<String>? accommodationTypes,
    List<String>? considerations,
    List<String>? selectedCities,
    List<String>? selectedKeywords,
  }) {
    return RecommendationState(
      currentPage: currentPage ?? this.currentPage,
      travelPeriod: travelPeriod ?? this.travelPeriod,
      travelDuration: travelDuration ?? this.travelDuration,
      companions: companions ?? this.companions,
      travelStyles: travelStyles ?? this.travelStyles,
      accommodationTypes: accommodationTypes ?? this.accommodationTypes,
      considerations: considerations ?? this.considerations,
      selectedCities: selectedCities ?? this.selectedCities,
      selectedKeywords: selectedKeywords ?? this.selectedKeywords,
    );
  }
}

class RecommendationNotifier extends StateNotifier<RecommendationState> {
  RecommendationNotifier() : super(RecommendationState());

  // 도시-카테고리 매핑
  static const Map<String, List<String>> cityCategories = {
    '일본': ['도쿄', '오사카', '시즈오카', '나고야', '삿포로', '후쿠오카', '교토', '나라'],
    '한국': ['서울', '부산', '제주', '강릉', '여수', '경주'],
    '동남아시아': ['방콕', '싱가포르', '발리', '세부', '다낭', '하노이', '호치민', '쿠알라룸푸르'],
    '미국': ['뉴욕', '로스앤젤레스', '샌프란시스코', '라스베가스', '시애틀', '하와이'],
    '유럽': ['파리', '런던', '로마', '바르셀로나', '암스테르담', '프라하', '비엔나', '베니스'],
  };

  // 도시의 카테고리를 찾는 메서드
  String? findCategoryForCity(String city) {
    for (var entry in cityCategories.entries) {
      if (entry.value.contains(city)) {
        return entry.key;
      }
    }
    return null;
  }

  // 같은 카테고리에서 랜덤하게 2개 도시 추천
  List<String> getRecommendedCitiesFromSameCategory(String selectedCity) {
    final category = findCategoryForCity(selectedCity);
    if (category == null) return [];

    final cities = List<String>.from(cityCategories[category]!);
    cities.remove(selectedCity); // 선택된 도시 제외
    cities.shuffle(); // 랜덤으로 섞기
    return cities.take(2).toList(); // 2개만 반환
  }

  // 기존 메서드들...
  void nextPage() {
    state = RecommendationState(
      currentPage: state.currentPage + 1,
      travelPeriod: state.travelPeriod,
      travelDuration: state.travelDuration,
      companions: state.companions,
      travelStyles: state.travelStyles,
      accommodationTypes: state.accommodationTypes,
      considerations: state.considerations,
      selectedCities: state.selectedCities,
    );
  }

  void selectTravelPeriod(String period) {
    state = RecommendationState(
      currentPage: state.currentPage,
      travelPeriod: period,
      travelDuration: state.travelDuration,
      companions: state.companions,
      travelStyles: state.travelStyles,
      accommodationTypes: state.accommodationTypes,
      considerations: state.considerations,
      selectedCities: state.selectedCities,
    );
  }

  void selectTravelDuration(String duration) {
    state = RecommendationState(
      currentPage: state.currentPage,
      travelPeriod: state.travelPeriod,
      travelDuration: duration,
      companions: state.companions,
      travelStyles: state.travelStyles,
      accommodationTypes: state.accommodationTypes,
      considerations: state.considerations,
      selectedCities: state.selectedCities,
    );
  }

  void toggleCity(String city) {
    final selectedCities = List<String>.from(state.selectedCities);
    if (selectedCities.contains(city)) {
      selectedCities.remove(city);
    } else {
      // 한 도시만 선택 가능하도록
      selectedCities.clear();
      selectedCities.add(city);
    }
    state = state.copyWith(selectedCities: selectedCities);
  }

  void toggleCompanion(String companion) {
    final companions = List<String>.from(state.companions);
    if (companions.contains(companion)) {
      companions.remove(companion);
    } else {
      companions.add(companion);
    }

    state = RecommendationState(
      currentPage: state.currentPage,
      travelPeriod: state.travelPeriod,
      travelDuration: state.travelDuration,
      companions: companions,
      travelStyles: state.travelStyles,
      accommodationTypes: state.accommodationTypes,
      considerations: state.considerations,
      selectedCities: state.selectedCities,
    );
  }

  void toggleTravelStyle(String style) {
    final styles = List<String>.from(state.travelStyles);
    if (styles.contains(style)) {
      styles.remove(style);
    } else {
      styles.add(style);
    }

    state = RecommendationState(
      currentPage: state.currentPage,
      travelPeriod: state.travelPeriod,
      travelDuration: state.travelDuration,
      companions: state.companions,
      travelStyles: styles,
      accommodationTypes: state.accommodationTypes,
      considerations: state.considerations,
      selectedCities: state.selectedCities,
    );
  }

  void toggleAccommodationType(String type) {
    final types = List<String>.from(state.accommodationTypes);
    if (types.contains(type)) {
      types.remove(type);
    } else {
      types.add(type);
    }

    state = RecommendationState(
      currentPage: state.currentPage,
      travelPeriod: state.travelPeriod,
      travelDuration: state.travelDuration,
      companions: state.companions,
      travelStyles: state.travelStyles,
      accommodationTypes: types,
      considerations: state.considerations,
      selectedCities: state.selectedCities,
    );
  }

  void toggleConsideration(String consideration) {
    final considerations = List<String>.from(state.considerations);
    if (consideration == '없음') {
      // '없음' 선택 시 다른 모든 고려사항 제거
      considerations.clear();
      considerations.add('없음');
    } else {
      // 다른 고려사항 선택 시 '없음' 제거
      if (considerations.contains('없음')) {
        considerations.remove('없음');
      }

      if (considerations.contains(consideration)) {
        considerations.remove(consideration);
      } else {
        considerations.add(consideration);
      }
    }

    state = RecommendationState(
      currentPage: state.currentPage,
      travelPeriod: state.travelPeriod,
      travelDuration: state.travelDuration,
      companions: state.companions,
      travelStyles: state.travelStyles,
      accommodationTypes: state.accommodationTypes,
      considerations: considerations,
      selectedCities: state.selectedCities,
    );
  }

  bool isAllOptionsSelected() {
    switch (state.currentPage) {
      case 0:
        return state.travelPeriod != null && state.travelDuration != null;
      case 1:
        return state.companions.isNotEmpty && state.travelStyles.isNotEmpty;
      case 2:
        return state.accommodationTypes.isNotEmpty &&
            (state.considerations.isNotEmpty ||
                state.considerations.contains('없음'));
      default:
        return false;
    }
  }

  void setState({String? selectedCity}) {
    if (selectedCity != null) {
      state = RecommendationState(
        currentPage: state.currentPage,
        travelPeriod: state.travelPeriod,
        travelDuration: state.travelDuration,
        companions: state.companions,
        travelStyles: state.travelStyles,
        accommodationTypes: state.accommodationTypes,
        considerations: state.considerations,
        selectedCities: [selectedCity],
      );
    }
  }

  void toggleKeyword(String keyword) {
    final keywords = List<String>.from(state.selectedKeywords);
    if (keywords.contains(keyword)) {
      keywords.remove(keyword);
    } else {
      keywords.add(keyword);
    }

    state = RecommendationState(
      currentPage: state.currentPage,
      travelPeriod: state.travelPeriod,
      travelDuration: state.travelDuration,
      companions: state.companions,
      travelStyles: state.travelStyles,
      accommodationTypes: state.accommodationTypes,
      considerations: state.considerations,
      selectedCities: state.selectedCities,
      selectedKeywords: keywords,
    );
  }

  void clearSelectedCities() {
    state = state.copyWith(selectedCities: []);
  }
}

final recommendationStateProvider =
    StateNotifierProvider<RecommendationNotifier, RecommendationState>(
        (ref) => RecommendationNotifier());

final recommendationProvider = FutureProvider.autoDispose
    .family<TravelRecommendation, SurveyResponse>((ref, survey) async {
  final geminiService = ref.read(geminiServiceProvider);
  final response = await geminiService.getTravelRecommendation(survey);
  return TravelRecommendation.fromGeminiResponse(response);
});
