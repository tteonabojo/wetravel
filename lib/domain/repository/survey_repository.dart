import 'package:wetravel/domain/entity/survey/survey_state.dart';

abstract class SurveyRepository {
  Future<void> saveSurveyState(SurveyState state);
  Future<SurveyState> getSurveyState();
  Future<void> clearSurveyState();
}
