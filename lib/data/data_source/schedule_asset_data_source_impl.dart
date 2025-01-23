import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:wetravel/data/dto/schedule_dto.dart';
import 'package:wetravel/data/data_source/schedule_data_source.dart';

class ScheduleAssetDataSourceImpl implements ScheduleDataSource {
  @override
  Future<List<ScheduleDto>> getSchedules() async {
    try {
      // assets 폴더의 json 파일 읽기
      final jsonString = await rootBundle.loadString('assets/data/schedules.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => ScheduleDto.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
}