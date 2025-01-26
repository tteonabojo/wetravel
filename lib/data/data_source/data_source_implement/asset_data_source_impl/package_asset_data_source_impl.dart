import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:wetravel/data/data_source/package_data_source.dart';
import 'package:wetravel/data/dto/package_dto.dart';

class PackageAssetDataSourceImpl implements PackageDataSource {
  PackageAssetDataSourceImpl(this._assetBundle);
  final AssetBundle _assetBundle;
  @override
  Future<List<PackageDto>> fetchPackages() async {
    final jsonString = await _assetBundle
        .loadString('assets/sample_data_asset_json/packages.json');
    return List.from(jsonDecode(jsonString))
        .map((e) => PackageDto.fromJson(e))
        .toList();
  }
}
