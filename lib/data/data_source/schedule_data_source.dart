import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wetravel/data/dto/schedule_dto.dart';

abstract class ScheduleDataSource {
  Future<List<ScheduleDto>> getSchedules();
}

class ScheduleDataSourceImpl implements ScheduleDataSource {
  final Dio dio;

  ScheduleDataSourceImpl({required this.dio});

  @override
  Future<List<ScheduleDto>> getSchedules() async {
    try {
      final response =
          await dio.get(dotenv.env['ANDROID_API_KEY']!); // 실제 API 엔드포인트에 맞게 수정
      final List<dynamic> jsonList = response.data;
      return jsonList.map((json) => ScheduleDto.fromJson(json)).toList();
    } catch (e) {
      // 에러 처리
      rethrow;
    }
  }
}
