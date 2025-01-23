import 'package:wetravel/data/dto/package_dto.dart';

abstract interface class PackageDataSource {
  Future<List<PackageDto>> fetchPackages();
}
