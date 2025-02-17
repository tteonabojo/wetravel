import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/domain/entity/survey_response.dart';
import 'package:wetravel/domain/entity/travel_schedule.dart';

/// 설문 상태를 관리하는 프로바이더
final surveyProvider =
    StateNotifierProvider<SurveyNotifier, SurveyState>((ref) {
  // SurveyResponse -> SurveyState로 변경
  return SurveyNotifier();
});

/// 설문 상태 클래스
class SurveyState {
  final int currentPage;
  final String? travelPeriod;
  final String? travelDuration;
  final List<String> companions;
  final List<String> travelStyles;
  final List<String> accommodationTypes;
  final List<String> considerations;
  final String? selectedCity;
  final TravelSchedule? savedSchedule;

  SurveyState({
    this.currentPage = 0,
    this.travelPeriod,
    this.travelDuration,
    this.companions = const [],
    this.travelStyles = const [],
    this.accommodationTypes = const [],
    this.considerations = const [],
    this.selectedCity,
    this.savedSchedule,
  });

  /// 현재 상태를 복사하여 새로운 상태를 생성
  SurveyState copyWith({
    int? currentPage,
    String? travelPeriod,
    String? travelDuration,
    List<String>? companions,
    List<String>? travelStyles,
    List<String>? accommodationTypes,
    List<String>? considerations,
    String? selectedCity,
    TravelSchedule? savedSchedule,
  }) {
    return SurveyState(
      currentPage: currentPage ?? this.currentPage,
      travelPeriod: travelPeriod ?? this.travelPeriod,
      travelDuration: travelDuration ?? this.travelDuration,
      companions: companions ?? this.companions,
      travelStyles: travelStyles ?? this.travelStyles,
      accommodationTypes: accommodationTypes ?? this.accommodationTypes,
      considerations: considerations ?? this.considerations,
      selectedCity: selectedCity ?? this.selectedCity,
      savedSchedule: savedSchedule ?? this.savedSchedule,
    );
  }

  /// 초기 상태
  factory SurveyState.initial() {
    return SurveyState(
      currentPage: 0,
      travelPeriod: null,
      travelDuration: null,
      companions: [],
      travelStyles: [],
      accommodationTypes: [],
      considerations: [],
      selectedCity: null,
      savedSchedule: null,
    );
  }

  /// SurveyState를 SurveyResponse로 변환
  SurveyResponse toSurveyResponse() {
    return SurveyResponse(
      selectedCity: selectedCity,
      travelPeriod: travelPeriod ?? '',
      travelDuration: travelDuration ?? '',
      companions: companions,
      travelStyles: travelStyles,
      accommodationTypes: accommodationTypes,
      considerations: considerations,
    );
  }

  /// 현재 페이지의 입력이 완료되었는지 확인
  bool isCurrentPageComplete() {
    switch (currentPage) {
      case 0: // 여행 기간 페이지
        return travelPeriod != null && travelDuration != null;
      case 1: // 여행 스타일 페이지
        return companions.isNotEmpty && travelStyles.isNotEmpty;
      case 2: // 숙소 및 고려사항 페이지
        return accommodationTypes.isNotEmpty && considerations.isNotEmpty;
      default:
        return false;
    }
  }

  /// 모든 필수 항목이 선택되었는지 확인
  bool get isComplete {
    return travelPeriod != null &&
        travelDuration != null &&
        companions.isNotEmpty &&
        travelStyles.isNotEmpty &&
        accommodationTypes.isNotEmpty &&
        considerations.isNotEmpty;
  }

  // UI 호환성을 위한 getter들
  String? get companion => companions.isNotEmpty ? companions.first : null;
  String? get travelStyle =>
      travelStyles.isNotEmpty ? travelStyles.first : null;
  String? get accommodationType =>
      accommodationTypes.isNotEmpty ? accommodationTypes.first : null;
  String? get consideration =>
      considerations.isNotEmpty ? considerations.first : null;
}

/// 설문 상태 관리 노티파이어
class SurveyNotifier extends StateNotifier<SurveyState> {
  SurveyNotifier() : super(SurveyState.initial());

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
    state = state.copyWith(companions: [...state.companions, companion]);
  }

  /// 여행 스타일 선택
  void selectTravelStyle(String style) {
    state = state.copyWith(travelStyles: [...state.travelStyles, style]);
  }

  /// 숙소 유형 선택
  void selectAccommodationType(String type) {
    state =
        state.copyWith(accommodationTypes: [...state.accommodationTypes, type]);
  }

  /// 고려사항 선택
  void selectConsideration(String consideration) {
    state = state
        .copyWith(considerations: [...state.considerations, consideration]);
  }

  /// 다음 페이지로 이동
  void nextPage() {
    state = state.copyWith(currentPage: state.currentPage + 1);
  }

  /// 상태 완전 초기화
  void resetState() {
    state = SurveyState.initial();
  }

  /// 현재 페이지 설정
  void setCurrentPage(int page) {
    state = state.copyWith(currentPage: page);
  }

  /// 선택한 도시 설정
  void setSelectedCity(String city) {
    state = state.copyWith(selectedCity: city);
  }

  /// 도시 정보만 유지하고 나머지 초기화
  void resetStateKeepingCity(String? city) {
    state = SurveyState.initial().copyWith(
      selectedCity: city,
    );
  }

  SurveyResponse toSurveyResponse() {
    return SurveyResponse(
      selectedCity: state.selectedCity,
      travelPeriod: state.travelPeriod ?? '',
      travelDuration: state.travelDuration ?? '',
      companions: state.companions,
      travelStyles: state.travelStyles,
      accommodationTypes: state.accommodationTypes,
      considerations: state.considerations,
    );
  }
}
