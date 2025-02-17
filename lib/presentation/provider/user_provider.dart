import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/firestore_constants.dart';
import 'package:wetravel/data/data_source/data_source_implement/user_data_source_impl.dart';
import 'package:wetravel/data/data_source/user_data_source.dart';
import 'package:wetravel/data/repository/user_repository_impl.dart';
import 'package:wetravel/domain/entity/schedule.dart';
import 'package:wetravel/domain/repository/user_repository.dart';
import 'package:wetravel/domain/usecase/fetch_user_usecase.dart';
import 'package:wetravel/domain/usecase/sign_in_with_provider_usecase.dart';

final _firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final _firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final _userDataSourceProvider = Provider<UserDataSource>((ref) {
  final firebaseFirestore = ref.watch(_firebaseFirestoreProvider);
  return UserDataSourceImpl(firebaseFirestore);
});

final userRepositoryProvider = Provider<UserRepository>(
  (ref) {
    final dataSource = ref.watch(_userDataSourceProvider);
    final firebaseFirestore =
        ref.watch(_firebaseFirestoreProvider); // firestore 의존성 추가
    final firebaseAuth =
        ref.watch(_firebaseAuthProvider); // firebaseAuth 의존성 추가
    return UserRepositoryImpl(dataSource, firebaseFirestore, firebaseAuth);
  },
);

final fetchUserUsecaseProvider = Provider(
  (ref) {
    final userRepo = ref.watch(userRepositoryProvider);
    return FetchUserUsecase(userRepo);
  },
);

/// 소셜 로그인
final signInWithProviderUsecaseProvider = Provider((ref) {
  final userRepo = ref.read(userRepositoryProvider);
  return SignInWithProviderUsecase(userRepo);
});

/// 로그아웃
final signOutUsecaseProvider =
    Provider((ref) => ref.read(userRepositoryProvider));

final userProvider = FutureProvider((ref) async {
  final fetchUserUsecase = ref.watch(fetchUserUsecaseProvider);
  return await fetchUserUsecase.execute();
});

final userStreamProvider = StreamProvider.autoDispose((ref) {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final firestoreConstants = FirestoreConstants();
  if (uid == null) return Stream.value(null);

  return FirebaseFirestore.instance
      .collection(firestoreConstants.usersCollection)
      .doc(uid)
      .snapshots()
      .map((snapshot) {
    return snapshot.data();
  });
});

// 현재 사용자의 schedules 컬렉션을 실시간으로 감시하는 provider
final schedulesStreamProvider = StreamProvider<List<Schedule>>((ref) {
  final user = ref.watch(userProvider).value;
  final firestoreConstants = FirestoreConstants();
  if (user == null) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection(firestoreConstants.usersCollection)
      .doc(user.id)
      .collection(firestoreConstants.schedulesCollection)
      .snapshots()
      .map((snapshot) {
    print('Schedules collection data: ${snapshot.docs}');
    return snapshot.docs
        .map((doc) => Schedule.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  });
});

final authStateChangesProvider = StreamProvider<User?>((ref) {
  final firebaseAuth = ref.watch(_firebaseAuthProvider);
  return firebaseAuth.authStateChanges(); // 인증 상태 변화를 실시간으로 추적
});

// 스케줄 관리를 위한 provider
final scheduleActionsProvider = Provider((ref) => ScheduleActions());

// 스케줄 관리 클래스
class ScheduleActions {
  final firestoreConstants = FirestoreConstants();
  Future<void> addSchedule(Schedule schedule) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final schedulesRef = FirebaseFirestore.instance
          .collection(firestoreConstants.usersCollection)
          .doc(user.uid)
          .collection(firestoreConstants.schedulesCollection);

      print('Adding schedule with ID: ${schedule.id}');
      print('Schedule data: ${schedule.toJson()}');

      await schedulesRef.doc(schedule.id).set(schedule.toJson());
      print('Schedule added successfully');
    } catch (e, stack) {
      print('Failed to add schedule: $e');
      print('Stack trace: $stack');
    }
  }

  Future<void> deleteSchedule(String scheduleId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection(firestoreConstants.usersCollection)
          .doc(user.uid)
          .collection(firestoreConstants.schedulesCollection)
          .doc(scheduleId)
          .delete();

      print('Schedule deleted successfully');
    } catch (e) {
      print('Failed to delete schedule: $e');
    }
  }
}
