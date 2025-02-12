import 'package:wetravel/domain/entity/survey/survey_state.dart';
import 'package:wetravel/domain/repository/survey_repository.dart';

class UpdateSurveyStateUseCase {
  final SurveyRepository repository;

  UpdateSurveyStateUseCase(this.repository);

  Future<void> execute(SurveyState state) {
    return repository.saveSurveyState(state);
  }
}
