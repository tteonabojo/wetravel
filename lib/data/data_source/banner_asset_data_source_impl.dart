import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:wetravel/data/dto/banner_dto.dart';
import 'package:wetravel/data/data_source/banner_data_source.dart';

class BannerAssetDataSourceImpl implements BannerDataSource {
  @override
  Future<List<BannerDto>> getBanners() async {
    try {
      // flutter에서 asset 파일 읽기
      final jsonString = await rootBundle.loadString('assets/data/banner.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => BannerDto.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
}