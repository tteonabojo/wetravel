import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:wetravel/data/dto/banner_dto.dart';

class BannerAssetDataSourceImpl {
  final AssetBundle assetBundle;

  // 생성자에서 assetBundle을 주입받을 수 있도록 수정
  BannerAssetDataSourceImpl({AssetBundle? assetBundle})
      : assetBundle = assetBundle ?? rootBundle;

  Future<List<BannerDto>> getBanners() async {
    final jsonString = await assetBundle.loadString('assets/data/banners.json');
    final List<dynamic> jsonData = jsonDecode(jsonString);
    return jsonData.map((e) => BannerDto.fromJson(e as Map<String, dynamic>)).toList();
  }
}
