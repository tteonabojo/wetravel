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
    List list = jsonDecode(jsonString);
    return list.map((ele) => PackageDto.fromJson(ele)).toList();
  }
}
