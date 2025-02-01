import 'package:wetravel/domain/entity/package.dart';

abstract interface class PackageRepository {
  Future<List<Package>> fetchPackages();

  Future<void> addPackage(Map<String, dynamic> packageData);
}
