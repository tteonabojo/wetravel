import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wetravel/data/data_source/user_data_source.dart';
import 'package:wetravel/data/dto/user_dto.dart';

class UserDataSourceImpl implements UserDataSource {
  UserDataSourceImpl(this._firestore);
  final FirebaseFirestore _firestore;

  // 현재 로그인된 사용자 정보 불러오기
  @override
  Future<UserDto?> fetchUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser; // 현재 로그인된 사용자 정보 가져오기
      if (user == null) {
        throw Exception('No user is currently logged in.');
      }

      final userId = user.uid;
      final docRef = _firestore.collection('users').doc(userId);
      final snapshot = await docRef.get();

      // 기존 사용자 데이터가 존재하는지 확인
      if (snapshot.exists) {
        // 기존 사용자 데이터 불러오기
        print('User exists in Firestore, loading data...');
        return UserDto.fromJson(snapshot.data()!);
      } else {
        // 신규 사용자 등록
        print('New user, creating document...');

        // 사용자 정보를 새로 등록
        final userDto = UserDto(
          id: userId,
          email: user.email ?? '',
          password: '',
          name: user.displayName, // 구글 닉네임
          imageUrl: user.photoURL ?? '',
          introduction: '',
          loginType: 'google',
          isGuide: false,
          createdAt: Timestamp.now(),
          updatedAt: null,
          deletedAt: null,
          scrapList: [], // 초기화된 scrapList
        );

        // 새 사용자 데이터 Firestore에 저장
        await docRef.set(userDto.toJson());

        // scrapList 서브컬렉션 생성
        final scrapListRef = docRef.collection('scrapList');
        for (var packageDto in userDto.scrapList!) {
          await scrapListRef.doc(packageDto.id).set(packageDto.toJson());
        }

        return userDto;
      }
    } catch (e) {
      print('Error fetching user: $e');
      rethrow;
    }
  }

  // 특정 userId로 사용자 데이터 불러오기
  @override
  Future<UserDto?> fetchUserById(String userId) async {
    try {
      final docRef = _firestore.collection('users').doc(userId);
      final snapshot = await docRef.get();

      // 사용자 데이터가 존재하면 반환
      if (snapshot.exists) {
        return UserDto.fromJson(snapshot.data()!);
      } else {
        return null; // 사용자가 존재하지 않으면 null 반환
      }
    } catch (e) {
      print('Error fetching user by ID: $e');
      rethrow;
    }
  }

  @override
  Future<void> saveUser(UserDto userDto) async {
    try {
      final docRef = _firestore.collection('users').doc(userDto.id);

      // 사용자 정보 저장
      await docRef.set(userDto.toJson(), SetOptions(merge: true));

      // scrapList를 서브컬렉션으로 저장
      final scrapListRef = docRef.collection('scrapList');

      // scrapList가 null이라면 빈 배열로 처리하고 서브컬렉션을 생성
      if (userDto.scrapList != null && userDto.scrapList!.isNotEmpty) {
        for (var packageDto in userDto.scrapList!) {
          await scrapListRef.doc(packageDto.id).set(packageDto.toJson());
        }
      } else if (userDto.scrapList == null || userDto.scrapList!.isEmpty) {
        // scrapList가 비어있다면 빈 서브컬렉션 생성 (빈 문서 추가)
        await scrapListRef
            .doc('empty')
            .set({'status': 'empty'}); // 'empty'라는 ID로 빈 문서를 추가
      }
    } catch (e) {
      print('Error saving user: $e');
      rethrow;
    }
  }
}
