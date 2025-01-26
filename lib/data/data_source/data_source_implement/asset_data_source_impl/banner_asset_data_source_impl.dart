import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:wetravel/data/data_source/banner_data_source.dart';
import 'package:wetravel/data/dto/banner_dto.dart';

class BannerAssetDataSourceImpl implements BannerDataSource {
  BannerAssetDataSourceImpl(this._assetBundle);
  final AssetBundle _assetBundle;
  @override
  Future<List<BannerDto>> fetchBanners() async {
    final jsonString = await _assetBundle
        .loadString('assets/sample_data_asset_json/banners.json');
    return List.from(jsonDecode(jsonString))
        .map((e) => BannerDto.fromJson(e))
        .toList();
  }
}
