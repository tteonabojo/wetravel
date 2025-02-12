import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wetravel/data/data_source/banner_data_source.dart';
import 'package:wetravel/data/data_source/data_source_implement/base_firestore_impl.dart';
import 'package:wetravel/data/dto/banner_dto.dart';

class BannerDataSourceImpl extends BaseFirestoreImpl
    implements BannerDataSource {
  BannerDataSourceImpl(FirebaseFirestore firestore)
      : super('banners', firestore);

  @override
  Future<List<BannerDto>> fetchBanners() async {
    try {
      final now = Timestamp.fromDate(DateTime.now());
      final banners = await firestore
          .collection(collectionName)
          .where('isHidden', isEqualTo: false)
          .where('startDate', isLessThanOrEqualTo: now)
          .where('endDate', isGreaterThanOrEqualTo: now)
          .orderBy('order', descending: false)
          .get();

      return banners.docs.map((e) => BannerDto.fromJson(e.data())).toList();
    } on Exception catch (e) {
      return [];
    }
  }
}
