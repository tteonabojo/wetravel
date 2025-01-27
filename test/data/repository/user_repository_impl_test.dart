// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:wetravel/data/data_source/user_data_source.dart';
// import 'package:wetravel/data/dto/user_dto.dart';
// import 'package:wetravel/data/repository/user_repository_impl.dart';

// class MockFirebaseAuth extends Mock implements FirebaseAuth {}

// class MockGoogleSignIn extends Mock implements GoogleSignIn {}

// class MockUserDataSource extends Mock implements UserDataSource {}

// class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

// void main() {
//   late final MockUserDataSource mockUserDataSource;
//   late final UserRepositoryImpl userRepositoryImpl;
//   late final MockFirebaseAuth mockFirebaseAuth;
//   late final MockGoogleSignIn mockGoogleSignIn;
//   late final MockFirebaseFirestore mockFirestore;

//   setUp(() {
//     mockUserDataSource = MockUserDataSource();
//     mockFirebaseAuth = MockFirebaseAuth();
//     mockGoogleSignIn = MockGoogleSignIn();
//     mockFirestore = MockFirebaseFirestore();
//     userRepositoryImpl = UserRepositoryImpl(
//         mockUserDataSource, mockFirebaseAuth, mockGoogleSignIn, mockFirestore);
//   });
//   test(
//     "UserRepositoryImpl test : fetchUser",
//     () async {
//       when(() => mockUserDataSource.fetchUser())
//           .thenAnswer((_) async => UserDto(
//                 id: 'id',
//                 email: 'email',
//                 password: 'password',
//                 name: 'name',
//                 imageUrl: 'imageUrl',
//                 introduction: 'introduction',
//                 loginType: 'loginType',
//                 isGuide: true,
//                 createdAt: Timestamp.now(),
//                 updatedAt: Timestamp.now(),
//                 deletedAt: Timestamp.now(),
//                 scrapList: [],
//               ));
//       final result = await userRepositoryImpl.fetchUser();
//       expect(result?.name, 'name');
//       expect(result!.email, 'email');
//     },
//   );
// }
