import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/data/repository/survey_repository_impl.dart';
import 'package:wetravel/domain/entity/survey/survey_state.dart';
import 'package:wetravel/domain/repository/survey_repository.dart';
import 'package:wetravel/domain/usecase/survey/get_survey_state_usecase.dart';
import 'package:wetravel/domain/usecase/survey/update_survey_state_usecase.dart';

final surveyRepositoryProvider = Provider<SurveyRepository>((ref) {
  return SurveyRepositoryImpl();
});

final surveyStateProvider =
    StateNotifierProvider<SurveyStateNotifier, SurveyState>((ref) {
  final repository = ref.watch(surveyRepositoryProvider);
  return SurveyStateNotifier(
    GetSurveyStateUseCase(repository),
    UpdateSurveyStateUseCase(repository),
  );
});

class SurveyStateNotifier extends StateNotifier<SurveyState> {
  final GetSurveyStateUseCase _getSurveyStateUseCase;
  final UpdateSurveyStateUseCase _updateSurveyStateUseCase;

  SurveyStateNotifier(
    this._getSurveyStateUseCase,
    this._updateSurveyStateUseCase,
  ) : super(SurveyState()) {
    _initState();
  }

  Future<void> _initState() async {
    state = await _getSurveyStateUseCase.execute();
  }

  void resetState({String? selectedCity}) {
    state = SurveyState(
      selectedCities: selectedCity != null ? [selectedCity] : [],
    );
    _updateSurveyStateUseCase.execute(state);
  }

  void selectTravelPeriod(String period) {
    print('Updating travel period to: $period');
    state = state.copyWith(travelPeriod: period);
    _updateSurveyStateUseCase.execute(state);
  }

  void selectTravelDuration(String duration) {
    state = state.copyWith(travelDuration: duration);
    _updateSurveyStateUseCase.execute(state);
  }

  void selectCompanion(String companion) {
    state = state.copyWith(companion: companion);
    _updateSurveyStateUseCase.execute(state);
  }

  void selectTravelStyle(String style) {
    state = state.copyWith(travelStyle: style);
    _updateSurveyStateUseCase.execute(state);
  }

  void selectAccommodationType(String type) {
    state = state.copyWith(accommodationType: type);
    _updateSurveyStateUseCase.execute(state);
  }

  void selectConsideration(String consideration) {
    state = state.copyWith(consideration: consideration);
    _updateSurveyStateUseCase.execute(state);
  }

  void previousPage() {
    if (state.currentPage > 0) {
      state = state.copyWith(currentPage: state.currentPage - 1);
      _updateSurveyStateUseCase.execute(state);
    }
  }

  bool isCurrentPageComplete() {
    switch (state.currentPage) {
      case 0:
        return state.travelPeriod != null && state.travelDuration != null;
      case 1:
        return state.companion != null && state.travelStyle != null;
      case 2:
        return state.accommodationType != null && state.consideration != null;
      default:
        return false;
    }
  }

  void nextPage() {
    state = state.copyWith(currentPage: state.currentPage + 1);
    _updateSurveyStateUseCase.execute(state);
  }

  bool isAllOptionsSelected() {
    return state.travelPeriod != null &&
        state.travelDuration != null &&
        state.companion != null &&
        state.travelStyle != null &&
        state.accommodationType != null &&
        state.consideration != null;
  }

  // 다른 상태 업데이트 메서드들...
}
