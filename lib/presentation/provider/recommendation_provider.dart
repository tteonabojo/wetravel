import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/domain/entity/survey_response.dart';
import 'package:wetravel/domain/entity/travel_recommendation.dart';
import 'package:wetravel/domain/services/gemini_service.dart';

export 'package:wetravel/domain/entity/survey_response.dart';

final geminiServiceProvider = Provider((ref) => GeminiService());

final recommendationProvider = FutureProvider.autoDispose
    .family<TravelRecommendation, SurveyResponse>((ref, survey) async {
  final geminiService = ref.read(geminiServiceProvider);
  final response = await geminiService.getTravelRecommendation(survey);
  return TravelRecommendation.fromGeminiResponse(response);
});

class RecommendationState {
  final int currentPage;
  final String? travelPeriod;
  final String? travelDuration;
  final List<String> companions;
  final List<String> travelStyles;
  final List<String> accommodationTypes;
  final List<String> considerations;
  final List<String> selectedCities;

  RecommendationState({
    this.currentPage = 0,
    this.travelPeriod,
    this.travelDuration,
    this.companions = const [],
    this.travelStyles = const [],
    this.accommodationTypes = const [],
    this.considerations = const [],
    this.selectedCities = const [],
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
    );
  }
}

final recommendationStateProvider =
    StateNotifierProvider<RecommendationProvider, RecommendationState>((ref) {
  return RecommendationProvider();
});

class RecommendationProvider extends StateNotifier<RecommendationState> {
  RecommendationProvider() : super(RecommendationState());

  // 도시-카테고리 매핑
  static const Map<String, Map<String, List<String>>> cityCategories = {
    '일본': {
      'cities': ['도쿄', '오사카', '시즈오카', '나고야', '삿포로', '후쿠오카', '교토', '나라'],
    },
    '한국': {
      'cities': ['서울', '부산', '제주', '강릉', '여수', '경주'],
    },
    '동남아시아': {
      'cities': ['방콕', '싱가포르', '발리', '세부', '다낭', '하노이', '호치민', '쿠알라룸푸르'],
    },
    '미국': {
      'cities': ['뉴욕', '로스앤젤레스', '샌프란시스코', '라스베가스', '시애틀', '하와이'],
    },
    '유럽': {
      'cities': ['파리', '런던', '로마', '바르셀로나', '암스테르담', '프라하', '비엔나', '베니스'],
    },
  };

  // 도시의 카테고리를 찾는 메서드
  String? findCategoryForCity(String city) {
    for (var entry in cityCategories.entries) {
      if (entry.value['cities']!.contains(city)) {
        return entry.key;
      }
    }
    return null;
  }

  // 같은 카테고리에서 랜덤하게 2개 도시 추천
  List<String> getRecommendedCitiesFromSameCategory(String selectedCity) {
    final category = findCategoryForCity(selectedCity);
    if (category == null) return [];

    final cities = List<String>.from(cityCategories[category]!['cities']!);
    cities.remove(selectedCity); // 선택된 도시 제외
    cities.shuffle(); // 랜덤으로 섞기
    return cities.take(2).toList(); // 2개만 반환
  }

  void nextPage() {
    if (state.currentPage < 2) {
      state = state.copyWith(currentPage: state.currentPage + 1);
    }
  }

  void selectTravelPeriod(String period) {
    state = state.copyWith(travelPeriod: period);
  }

  void selectTravelDuration(String duration) {
    state = state.copyWith(travelDuration: duration);
  }

  void toggleCompanion(String companion) {
    final List<String> updatedCompanions = List.from(state.companions);
    if (updatedCompanions.contains(companion)) {
      updatedCompanions.remove(companion);
    } else {
      updatedCompanions.add(companion);
    }
    state = state.copyWith(companions: updatedCompanions);
  }

  void toggleTravelStyle(String style) {
    final List<String> updatedStyles = List.from(state.travelStyles);
    if (updatedStyles.contains(style)) {
      updatedStyles.remove(style);
    } else {
      updatedStyles.add(style);
    }
    state = state.copyWith(travelStyles: updatedStyles);
  }

  void toggleAccommodationType(String type) {
    final List<String> updatedTypes = List.from(state.accommodationTypes);
    if (updatedTypes.contains(type)) {
      updatedTypes.remove(type);
    } else {
      updatedTypes.add(type);
    }
    state = state.copyWith(accommodationTypes: updatedTypes);
  }

  void toggleConsideration(String consideration) {
    final List<String> updatedConsiderations = List.from(state.considerations);
    if (updatedConsiderations.contains(consideration)) {
      updatedConsiderations.remove(consideration);
    } else {
      updatedConsiderations.add(consideration);
    }
    state = state.copyWith(considerations: updatedConsiderations);
  }

  void toggleCity(String city) {
    if (state.selectedCities.contains(city)) {
      state = state.copyWith(selectedCities: []);
    } else {
      state = state.copyWith(selectedCities: [city]);
    }
  }

  bool isAllOptionsSelected() {
    switch (state.currentPage) {
      case 0:
        if (state.selectedCities.isNotEmpty) return true;
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
      state = state.copyWith(selectedCities: [selectedCity]);
    }
  }
}
