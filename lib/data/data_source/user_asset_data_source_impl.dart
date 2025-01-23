import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:wetravel/data/data_source/user_data_source.dart';
import 'package:wetravel/data/dto/user_dto.dart';

class UserAssetDataSourceImpl implements UserDataSource {
  UserAssetDataSourceImpl(this._assetBundle);
  final AssetBundle _assetBundle;

  @override
  Future<List<UserDto>> fetchUsers() async {
    final jsonString = await _assetBundle.loadString('assets/json/users.json');
    List list = jsonDecode(jsonString);
    return list.map((ele) => UserDto.fromJson(ele)).toList();
  }
}
