import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wetravel/data/data_source/package_data_source.dart';
import 'package:wetravel/data/dto/package_dto.dart';

class PackageDataSourceImpl implements PackageDataSource {
  PackageDataSourceImpl(this._firestore);
  final FirebaseFirestore _firestore;

  @override
  Future<List<PackageDto>> fetchPackages() async {
    final collectionRef = _firestore.collection('packages');
    final snapshot = await collectionRef.get();
    final documentSnapshot = snapshot.docs;
    for (var docSnapshot in documentSnapshot) {
      print(docSnapshot.id);
      print(docSnapshot.data());
    }
    return documentSnapshot.map((e) => PackageDto.fromJson(e.data())).toList();
  }

  @override
  Future<void> addPackage(Map<String, dynamic> packageData) async {
    await _firestore.collection('packages').add(packageData);
  }

  @override
  Future<List<PackageDto>> fetchPackagesByUserId(String userId) async {
    final snapshot = await _firestore
        .collection('packages')
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs.map((doc) {
      return PackageDto.fromJson(doc.data());
    }).toList();
  }
}
