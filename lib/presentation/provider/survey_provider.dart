import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/domain/entity/survey_response.dart';

/// 설문 상태를 관리하는 프로바이더
final surveyProvider =
    StateNotifierProvider<SurveyNotifier, SurveyState>((ref) {
  // SurveyResponse -> SurveyState로 변경
  return SurveyNotifier();
});

/// 설문 상태 클래스
class SurveyState {
  final int currentPage;
  final String? travelPeriod; // 여행 시기
  final String? travelDuration; // 여행 기간
  final String? companion; // 동행인
  final String? travelStyle; // 여행 스타일
  final String? accommodationType; // 숙소 유형
  final String? consideration; // 고려사항
  final String? selectedCity; // 1순위로 선택한 도시

  SurveyState({
    this.currentPage = 0,
    this.travelPeriod,
    this.travelDuration,
    this.companion,
    this.travelStyle,
    this.accommodationType,
    this.consideration,
    this.selectedCity, // 선택한 도시
  });

  /// 현재 상태를 복사하여 새로운 상태를 생성
  SurveyState copyWith({
    int? currentPage,
    String? travelPeriod,
    String? travelDuration,
    String? companion,
    String? travelStyle,
    String? accommodationType,
    String? consideration,
    String? selectedCity, // 선택한 도시
  }) {
    return SurveyState(
      currentPage: currentPage ?? this.currentPage,
      travelPeriod: travelPeriod ?? this.travelPeriod,
      travelDuration: travelDuration ?? this.travelDuration,
      companion: companion ?? this.companion,
      travelStyle: travelStyle ?? this.travelStyle,
      accommodationType: accommodationType ?? this.accommodationType,
      consideration: consideration ?? this.consideration,
      selectedCity: selectedCity ?? this.selectedCity, // 선택한 도시
    );
  }

  /// SurveyState를 SurveyResponse로 변환
  SurveyResponse toSurveyResponse() {
    print('Converting SurveyState to SurveyResponse:');
    print('1순위 선택 도시: $selectedCity'); // 디버깅 메시지 수정
    print('Travel Period: $travelPeriod');
    print('Travel Duration: $travelDuration');
    print('Companion: $companion');
    print('Travel Style: $travelStyle');

    return SurveyResponse(
      selectedCity: selectedCity, // 1순위 도시를 SurveyResponse에 전달
      travelPeriod: travelPeriod ?? '',
      travelDuration: travelDuration ?? '',
      companions: companion != null ? [companion!] : [],
      travelStyles: travelStyle != null ? [travelStyle!] : [],
      accommodationTypes: accommodationType != null ? [accommodationType!] : [],
      considerations: consideration != null ? [consideration!] : [],
    );
  }

  /// 현재 페이지의 입력이 완료되었는지 확인
  bool isCurrentPageComplete() {
    switch (currentPage) {
      case 0: // 여행 기간 페이지
        return travelPeriod != null && travelDuration != null;
      case 1: // 여행 스타일 페이지
        return companion != null && travelStyle != null;
      case 2: // 숙소 및 고려사항 페이지
        return accommodationType != null && consideration != null;
      default:
        return false;
    }
  }

  /// 모든 필수 항목이 선택되었는지 확인
  bool get isComplete {
    return travelPeriod != null &&
        travelDuration != null &&
        companion != null &&
        travelStyle != null &&
        accommodationType != null &&
        consideration != null;
  }
}

/// 설문 상태 관리 노티파이어
class SurveyNotifier extends StateNotifier<SurveyState> {
  SurveyNotifier() : super(SurveyState());

  /// 여행 시기 선택
  void selectTravelPeriod(String period) {
    state = state.copyWith(travelPeriod: period);
  }

  /// 여행 기간 선택
  void selectTravelDuration(String duration) {
    state = state.copyWith(travelDuration: duration);
  }

  /// 동행인 선택
  void selectCompanion(String companion) {
    state = state.copyWith(companion: companion);
  }

  /// 여행 스타일 선택
  void selectTravelStyle(String style) {
    state = state.copyWith(travelStyle: style);
  }

  /// 숙소 유형 선택
  void selectAccommodationType(String type) {
    state = state.copyWith(accommodationType: type);
  }

  /// 고려사항 선택
  void selectConsideration(String consideration) {
    state = state.copyWith(consideration: consideration);
  }

  /// 다음 페이지로 이동
  void nextPage() {
    state = state.copyWith(currentPage: state.currentPage + 1);
  }

  /// 1순위 도시 설정
  void setSelectedCity(String city) {
    print('Setting selected city as priority: $city'); // 디버깅용
    state = state.copyWith(selectedCity: city);
  }

  /// 상태 초기화 (선택된 도시 유지)
  void resetState() {
    final currentCity = state.selectedCity;
    state = SurveyState(selectedCity: currentCity);
  }

  /// 현재 페이지 설정
  void setCurrentPage(int page) {
    state = state.copyWith(currentPage: page);
  }
}
