import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/data/repository/saved_plans_repository_impl.dart';
import 'package:wetravel/domain/usecase/get_saved_plans_count_usecase.dart';
import 'package:wetravel/domain/repository/saved_plans_repository.dart';

final savedPlansRepositoryProvider = Provider<SavedPlansRepository>((ref) {
  return SavedPlansRepositoryImpl(
    FirebaseFirestore.instance,
    FirebaseAuth.instance,
  );
});

final getSavedPlansCountUseCaseProvider =
    Provider<GetSavedPlansCountUseCase>((ref) {
  return GetSavedPlansCountUseCase(ref.watch(savedPlansRepositoryProvider));
});
