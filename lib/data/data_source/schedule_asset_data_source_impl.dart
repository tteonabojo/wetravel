import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:wetravel/data/dto/schedule_dto.dart';

class ScheduleAssetDataSourceImpl {
  final AssetBundle assetBundle;

  ScheduleAssetDataSourceImpl({required this.assetBundle});

  Future<List<ScheduleDto>> getSchedules() async {
    final jsonString = await assetBundle.loadString('assets/data/schedules.json');
    final List<dynamic> jsonData = jsonDecode(jsonString);
    return jsonData.map((e) => ScheduleDto.fromJson(e)).toList();
  }
}