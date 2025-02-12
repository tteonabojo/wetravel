import 'package:wetravel/domain/entity/survey/survey_state.dart';
import 'package:wetravel/domain/repository/survey_repository.dart';

class SurveyRepositoryImpl implements SurveyRepository {
  SurveyState? _currentState;

  @override
  Future<SurveyState> getSurveyState() async {
    return _currentState ?? SurveyState();
  }

  @override
  Future<void> saveSurveyState(SurveyState state) async {
    _currentState = state;
  }

  @override
  Future<void> clearSurveyState() async {
    _currentState = null;
  }
}
