import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wetravel/core/constants/firestore_constants.dart';
import 'package:wetravel/data/data_source/banner_data_source.dart';
import 'package:wetravel/data/dto/banner_dto.dart';

class BannerDataSourceImpl extends FirestoreConstants
    implements BannerDataSource {
  final FirebaseFirestore _firestore;
  BannerDataSourceImpl(this._firestore);

  @override
  Future<List<BannerDto>> fetchBanners() async {
    try {
      final now = Timestamp.fromDate(DateTime.now());
      final banners = await _firestore
          .collection(bannersCollection)
          .where('isHidden', isEqualTo: false)
          .where('startDate', isLessThanOrEqualTo: now)
          .where('endDate', isGreaterThanOrEqualTo: now)
          .orderBy('order', descending: false)
          .get();
      return banners.docs.map((e) => BannerDto.fromJson(e.data())).toList();
    } on Exception catch (e) {
      log('$e');
      return [];
    }
  }
}
