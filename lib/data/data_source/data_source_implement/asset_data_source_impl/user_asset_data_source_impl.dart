import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:wetravel/data/data_source/user_data_source.dart';
import 'package:wetravel/data/dto/user_dto.dart';

class UserAssetDataSourceImpl implements UserDataSource {
  UserAssetDataSourceImpl(this._assetBundle);
  final AssetBundle _assetBundle;
  @override
  Future<List<UserDto>> fetchUsers() async {
    final jsonString = await _assetBundle
        .loadString('assets/sample_data_asset_json/users.json');
    return List.from(jsonDecode(jsonString))
        .map((e) => UserDto.fromJson(e))
        .toList();
  }
}
