import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/domain/entity/survey_response.dart';
import 'package:wetravel/domain/entity/travel_recommendation.dart';
import 'package:wetravel/domain/services/gemini_service.dart';

final geminiServiceProvider = Provider((ref) => GeminiService());

/// 여행 추천 상태를 관리하는 클래스
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
  final List<String> destinations;
  final List<String> reasons;

  /// 도시-카테고리 매핑 정보
  final Map<String, List<String>> cityCategories = {
    '일본': ['도쿄', '오사카', '교토', '나라', '후쿠오카', '삿포로'],
    '한국': ['서울', '부산', '제주', '강릉', '여수', '경주'],
    '동남아시아': ['방콕', '싱가포르', '발리', '세부', '다낭', '하노이'],
    '미국': ['뉴욕', '로스앤젤레스', '샌프란시스코', '라스베가스', '하와이'],
    '유럽': ['파리', '런던', '로마', '바르셀로나', '암스테르담', '프라하', '베니스'],
  };

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
    required this.destinations,
    required this.reasons,
  });

  /// 상태 복사 메서드
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
    List<String>? destinations,
    List<String>? reasons,
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
      destinations: destinations ?? this.destinations,
      reasons: reasons ?? this.reasons,
    );
  }

  /// 선택된 도시와 같은 카테고리의 추천 도시 목록을 반환
  List<String> getRecommendedCitiesFromSameCategory(String selectedCity) {
    String? category = _findCategoryForCity(selectedCity);
    if (category == null) return [];

    return cityCategories[category]!
        .where((city) => city != selectedCity)
        .take(2)
        .toList();
  }

  /// 도시가 속한 카테고리를 찾는 메서드
  String? _findCategoryForCity(String city) {
    for (var entry in cityCategories.entries) {
      if (entry.value.contains(city)) {
        return entry.key;
      }
    }
    return null;
  }
}

/// 여행 추천 상태 관리 노티파이어
class RecommendationNotifier extends StateNotifier<RecommendationState> {
  RecommendationNotifier()
      : super(RecommendationState(
          destinations: [],
          reasons: [],
        ));

  /// 도시-카테고리 매핑 정보 (상세 버전)
  static const Map<String, List<String>> cityCategories = {
    '일본': ['도쿄', '오사카', '시즈오카', '나고야', '삿포로', '후쿠오카', '교토', '나라'],
    '한국': ['서울', '부산', '제주', '강릉', '여수', '경주'],
    '동남아시아': ['방콕', '싱가포르', '발리', '세부', '다낭', '하노이', '호치민', '쿠알라룸푸르'],
    '미국': ['뉴욕', '로스앤젤레스', '샌프란시스코', '라스베가스', '시애틀', '하와이'],
    '유럽': ['파리', '런던', '로마', '바르셀로나', '암스테르담', '프라하', '비엔나', '베니스'],
  };

  /// 도시의 카테고리를 찾는 메서드
  String? findCategoryForCity(String city) {
    for (var entry in cityCategories.entries) {
      if (entry.value.contains(city)) {
        return entry.key;
      }
    }
    return null;
  }

  /// 같은 카테고리에서 랜덤하게 2개 도시 추천
  List<String> getRecommendedCitiesFromSameCategory(String selectedCity) {
    final category = findCategoryForCity(selectedCity);
    if (category == null) return [];

    final cities = List<String>.from(cityCategories[category]!);
    cities.remove(selectedCity); // 선택된 도시 제외
    cities.shuffle(); // 랜덤으로 섞기
    return cities.take(2).toList(); // 2개만 반환
  }

  /// 다음 페이지로 이동
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
      destinations: state.destinations,
      reasons: state.reasons,
    );
  }

  /// 여행 기간 선택
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
      destinations: state.destinations,
      reasons: state.reasons,
    );
  }

  /// 여행 일수 선택
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
      destinations: state.destinations,
      reasons: state.reasons,
    );
  }

  /// 도시 토글 (선택/해제)
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

  /// 동행인 토글
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
      destinations: state.destinations,
      reasons: state.reasons,
    );
  }

  /// 여행 스타일 토글
  void toggleTravelStyle(String style) {
    final styles = List<String>.from(state.travelStyles);
    if (styles.contains(style)) {
      styles.remove(style);
    } else {
      styles.add(style);
    }

    state = state.copyWith(travelStyles: styles);
  }

  /// 숙소 유형 토글
  void toggleAccommodationType(String type) {
    final types = List<String>.from(state.accommodationTypes);
    if (types.contains(type)) {
      types.remove(type);
    } else {
      types.add(type);
    }

    state = state.copyWith(accommodationTypes: types);
  }

  /// 고려사항 토글
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

    state = state.copyWith(considerations: considerations);
  }

  /// 모든 옵션이 선택되었는지 확인
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

  /// 현재 페이지의 선택이 완료되었는지 확인
  bool isCurrentPageComplete() {
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

  /// 설문 응답으로 상태 초기화
  void initializeFromSurvey(SurveyResponse survey) {
    state = state.copyWith(
      currentPage: 0,
      selectedCities: [if (survey.selectedCity != null) survey.selectedCity!],
      travelPeriod: survey.travelPeriod,
      travelDuration: survey.travelDuration,
      companions: survey.companions,
      travelStyles: survey.travelStyles,
      accommodationTypes: survey.accommodationTypes,
      considerations: survey.considerations,
      destinations: [], // 빈 배열로 초기화
      reasons: [], // 빈 배열로 초기화
    );
  }

  /// 상태 초기화
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
      selectedKeywords: [],
      destinations: [],
      reasons: [],
    );
  }

  void previousPage() {}
}

/// 추천 상태 프로바이더
final recommendationStateProvider =
    StateNotifierProvider<RecommendationNotifier, RecommendationState>(
        (ref) => RecommendationNotifier());

/// AI 추천 프로바이더
final recommendationProvider = FutureProvider.autoDispose
    .family<TravelRecommendation, SurveyResponse>((ref, survey) async {
  try {
    print('Provider called with survey:');
    print('Travel Period: ${survey.travelPeriod}');
    print('Travel Duration: ${survey.travelDuration}');
    print('Companions: ${survey.companions}');
    print('Travel Styles: ${survey.travelStyles}');
    print('Selected City: ${survey.selectedCity}');

    final geminiService = ref.read(geminiServiceProvider);

    // 빈 문자열이나 빈 리스트 체크
    if (survey.travelPeriod.isEmpty ||
        survey.travelDuration.isEmpty ||
        survey.companions.isEmpty ||
        survey.travelStyles.isEmpty) {
      throw Exception('필수 설문 응답이 누락되었습니다.');
    }

    List<String>? preferredCities;

    // 선택된 도시가 있는 경우
    if (survey.selectedCity != null && survey.selectedCity!.isNotEmpty) {
      final notifier = ref.read(recommendationStateProvider.notifier);
      final recommendedCities =
          notifier.getRecommendedCitiesFromSameCategory(survey.selectedCity!);
      preferredCities = [survey.selectedCity!, ...recommendedCities];

      print('Using preferred cities: $preferredCities');
    }

    final response = await geminiService.getTravelRecommendation(
      survey,
      preferredCities: preferredCities,
    );

    return TravelRecommendation.fromGeminiResponse(
      response,
      preferredCities: preferredCities ?? [],
    );
  } catch (e, stack) {
    print('Error in recommendation provider: $e');
    print('Stack trace: $stack');
    rethrow;
  }
});
