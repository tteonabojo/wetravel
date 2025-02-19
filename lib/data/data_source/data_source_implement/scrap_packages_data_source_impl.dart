import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wetravel/core/constants/firestore_constants.dart';
import 'package:wetravel/data/data_source/scrap_packages_data_source.dart';

class ScrapPackagesDataSourceImpl extends FirestoreConstants
    implements ScrapPackagesDataSource {
  final FirebaseFirestore _firestore;

  ScrapPackagesDataSourceImpl(this._firestore);

  @override
  Stream<List<Map<String, dynamic>>> getScrapPackages(String userId) {
    return _firestore
        .collection(usersCollection)
        .doc(userId)
        .collection('schedule')
        .where('isAIRecommended', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}
