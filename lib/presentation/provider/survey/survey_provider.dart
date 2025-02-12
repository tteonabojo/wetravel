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
    state = state.copyWith(travelPeriod: period);
    _updateSurveyStateUseCase.execute(state);
  }

  void selectTravelDuration(String duration) {
    state = state.copyWith(travelDuration: duration);
    _updateSurveyStateUseCase.execute(state);
  }

  void toggleCompanion(String companion) {
    final updatedCompanions = List<String>.from(state.companions);
    if (updatedCompanions.contains(companion)) {
      updatedCompanions.remove(companion);
    } else {
      updatedCompanions.add(companion);
    }
    state = state.copyWith(companions: updatedCompanions);
    _updateSurveyStateUseCase.execute(state);
  }

  void toggleTravelStyle(String style) {
    // 비슷한 구현
  }

  void toggleAccommodationType(String type) {
    // 비슷한 구현
  }

  bool isCurrentPageComplete() {
    // 현재 페이지의 완성도 체크 로직
    return true;
  }

  void nextPage() {
    state = state.copyWith(currentPage: state.currentPage + 1);
    _updateSurveyStateUseCase.execute(state);
  }

  // 다른 상태 업데이트 메서드들...
}
