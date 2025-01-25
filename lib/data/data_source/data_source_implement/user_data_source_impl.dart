import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wetravel/data/data_source/user_data_source.dart';
import 'package:wetravel/data/dto/user_dto.dart';

class UserDataSourceImpl implements UserDataSource {
  UserDataSourceImpl(this._firestore);
  final FirebaseFirestore _firestore;

  @override
  Future<List<UserDto>> fetchUsers() async {
    FirebaseFirestore firestore = _firestore;
    final collectionRef = firestore.collection('users');
    final snapshot = await collectionRef.get();
    final documentSnapshot = snapshot.docs;
    for (var docSnapshot in documentSnapshot) {
      print(docSnapshot.id);
      print(docSnapshot.data());
    }
    return documentSnapshot.map((e) => UserDto.fromJson(e.data())).toList();
  }
}
