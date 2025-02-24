import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wetravel/core/constants/firestore_constants.dart';
import 'package:wetravel/data/data_source/user_data_source.dart';
import 'package:wetravel/domain/entity/user.dart';
import 'package:wetravel/domain/repository/user_repository.dart';
import 'package:wetravel/data/dto/user_dto.dart';

class UserRepositoryImpl extends FirestoreConstants implements UserRepository {
  UserRepositoryImpl(
    this._userDataSource,
    this._firebaseFirestore,
    this._firebaseAuth,
  );

  final UserDataSource _userDataSource;
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseAuth.FirebaseAuth _firebaseAuth;

  @override
  Future<User> fetchUser() async {
    final userId = _firebaseAuth.currentUser?.uid;
    if (userId == null) {
      throw Exception("No user is logged in.");
    }

    final docSnapshot =
        await _firebaseFirestore.collection(usersCollection).doc(userId).get();

    if (!docSnapshot.exists) {
      throw Exception('User not found');
    }

    // UserDto에서 User로 변환
    return User.fromDto(UserDto.fromJson(docSnapshot.data() ?? {}));
  }

  @override
  Future<User> signInWithProvider({required provider}) async {
    final result = await _userDataSource.signInWithProvider(provider: provider);
    return result.toEntity();
  }

  @override
  Future<bool> signOut() async {
    return await _userDataSource.signOut();
  }

  // 추후 구현
  @override
  Future<bool> signUp({required String email, required String password}) {
    // TODO: implement signUp
    throw UnimplementedError();
  }

  // 추후 구현
  @override
  Future<User> signIn({required String email, required String password}) {
    // TODO: implement signIn
    throw UnimplementedError();
  }

  @override
  Future<List<User>> fetchUsersByIds(List<String> ids) async {
    final userDtos = await _userDataSource.fetchUsersByIds(ids);
    return userDtos.map((e) => User.fromDto(e)).toList();
  }
}
