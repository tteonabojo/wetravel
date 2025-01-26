import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:wetravel/data/data_source/schedule_data_source.dart';
import 'package:wetravel/data/dto/schedule_dto.dart';

class ScheduleAssetDataSourceImpl implements ScheduleDataSource {
  ScheduleAssetDataSourceImpl(this._assetBundle);
  final AssetBundle _assetBundle;
  @override
  Future<List<ScheduleDto>> fetchSchedules() async {
    final jsonString = await _assetBundle
        .loadString('assets/sample_data_asset_json/schedules.json');
    return List.from(jsonDecode(jsonString))
        .map((e) => ScheduleDto.fromJson(e))
        .toList();
  }
}
