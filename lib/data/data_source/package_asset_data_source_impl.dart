import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wetravel/data/data_source/package_data_source.dart';
import 'package:wetravel/data/dto/package_dto.dart';

class PackageAssetDataSourceImpl implements PackageDataSource {
  PackageAssetDataSourceImpl(this._assetBundle);
  final AssetBundle _assetBundle;

  @override
  Future<List<PackageDto>> fetchPackages() async {
    final jsonString =
        await _assetBundle.loadString('assets/json/packages.json');
    final list = jsonDecode(jsonString);
    return [PackageDto.fromJson(list)];
  }
}
