import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wetravel/data/data_source/banner_data_source.dart';
import 'package:wetravel/data/dto/banner_dto.dart';

class BannerDataSourceImpl implements BannerDataSource {
  BannerDataSourceImpl(this._firestore);
  final FirebaseFirestore _firestore;

  @override
  Future<List<BannerDto>> fetchBanners() async {
    FirebaseFirestore firestore = _firestore;
    final collectionRef = firestore.collection('banners');
    final snapshot = await collectionRef.get();
    final documentSnapshot = snapshot.docs;
    for (var docSnapshot in documentSnapshot) {
      print(docSnapshot.id);
      print(docSnapshot.data());
    }
    return documentSnapshot.map((e) => BannerDto.fromJson(e.data())).toList();
  }
}
