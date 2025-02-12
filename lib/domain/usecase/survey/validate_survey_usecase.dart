import 'package:wetravel/domain/entity/survey/survey_state.dart';

class ValidateSurveyUseCase {
  Future<bool> execute(SurveyState state) async {
    // 설문 데이터 유효성 검증 로직
    return true;
  }
}

class SubmitSurveyUseCase {
  Future<void> execute(SurveyState state) async {
    // 설문 제출 로직
  }
}
