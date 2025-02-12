import 'package:wetravel/domain/entity/survey/survey_state.dart';
import 'package:wetravel/domain/repository/survey_repository.dart';

class GetSurveyStateUseCase {
  final SurveyRepository repository;

  GetSurveyStateUseCase(this.repository);

  Future<SurveyState> execute() {
    return repository.getSurveyState();
  }
}
