import 'package:wetravel/domain/repository/saved_plans_repository.dart';

class GetSavedPlansCountUseCase {
  final SavedPlansRepository repository;

  GetSavedPlansCountUseCase(this.repository);

  Future<int> execute() async {
    return await repository.getSavedPlansCount();
  }
}
