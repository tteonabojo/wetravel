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

  // 상태 초기화 메서드 추가
  RecommendationState reset() {
    return RecommendationState(
      currentPage: 0,
      travelPeriod: null,
      travelDuration: null,
      companions: [],
      travelStyles: [],
      accommodationTypes: [],
      considerations: [],
      selectedCities: [],
    );
  }

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

class RecommendationNotifier extends StateNotifier<RecommendationState> {
  RecommendationNotifier() : super(RecommendationState());

  void resetState({String? selectedCity}) {
    state = RecommendationState(
      currentPage: 0,
      selectedCities: selectedCity != null ? [selectedCity] : [],
      travelPeriod: null,
      travelDuration: null,
      companions: [],
      travelStyles: [],
      accommodationTypes: [],
      considerations: [],
    );
  }

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
    final cities = List<String>.from(state.selectedCities);
    if (cities.contains(city)) {
      cities.remove(city);
    } else {
      cities.clear(); // 한 도시만 선택 가능하도록
      cities.add(city);
    }

    state = RecommendationState(
      currentPage: state.currentPage,
      travelPeriod: state.travelPeriod,
      travelDuration: state.travelDuration,
      companions: state.companions,
      travelStyles: state.travelStyles,
      accommodationTypes: state.accommodationTypes,
      considerations: state.considerations,
      selectedCities: cities,
    );
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

  // 여행지별 태그 매핑을 추가
  Map<String, List<String>> getCityTags(
      String city, List<String> travelStyles) {
    final tags = <String, List<String>>{
      // 일본
      '도쿄': ['현대적', '쇼핑천국'],
      '오사카': ['맛집여행', '활기찬'],
      '교토': ['전통문화', '고즈넉한'],
      '나라': ['역사유적', '자연친화'],
      '후쿠오카': ['먹방투어', '도시여행'],
      '삿포로': ['시원한 기후', '겨울축제'],

      // 한국
      '서울': ['케이컬처', '트렌디'],
      '부산': ['해양도시', '먹방투어'],
      '제주': ['자연경관', '휴양'],
      '강릉': ['바다여행', '카페거리'],
      '여수': ['밤바다', '해산물'],
      '경주': ['역사유적', '고도'],

      // 동남아시아
      '방콕': ['열대기후', '불교문화'],
      '싱가포르': ['현대도시', '다문화'],
      '발리': ['휴양지', '열대기후'],
      '세부': ['해변휴양', '액티비티'],
      '다낭': ['해변도시', '리조트'],
      '하노이': ['전통문화', '역사적'],

      // 미국
      '뉴욕': ['도시여행', '문화예술'],
      '로스앤젤레스': ['엔터테인먼트', '해변'],
      '샌프란시스코': ['다문화', '베이에리어'],
      '라스베가스': ['카지노', '엔터테인먼트'],
      '하와이': ['휴양지', '열대기후'],

      // 유럽
      '파리': ['예술의도시', '로맨틱'],
      '런던': ['역사문화', '현대적'],
      '로마': ['고대유적', '예술'],
      '바르셀로나': ['건축예술', '지중해'],
      '암스테르담': ['운하도시', '예술'],
      '프라하': ['중세도시', '낭만적'],
      '베니스': ['수상도시', '로맨틱'],
    };

    // 기본 태그 설정
    List<String> cityTags = tags[city] ?? ['도시여행', '관광'];

    // 여행 스타일에 따른 추가 태그
    if (travelStyles.contains('맛집')) {
      cityTags = ['맛집투어', ...cityTags];
    }
    if (travelStyles.contains('쇼핑')) {
      cityTags = ['쇼핑', ...cityTags];
    }

    return {'tags': cityTags.take(2).toList()}; // 최대 2개의 태그만 반환
  }

  void selectSingleCity(String city) {
    state = state.copyWith(selectedCities: [city]);
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
