import 'package:dio/dio.dart';
import 'package:wetravel/data/dto/schedule_dto.dart';

abstract class ScheduleRemoteDataSource {
  Future<List<ScheduleDto>> getSchedules();
}

class ScheduleRemoteDataSourceImpl implements ScheduleRemoteDataSource {
  final Dio dio;

  ScheduleRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ScheduleDto>> getSchedules() async {
    try {
      final response = await dio.get('AIzaSyD9FXUs9pi8RkbNx5smRb3ozstlyv5bVIE'); // 실제 API 엔드포인트에 맞게 수정
      final List<dynamic> jsonList = response.data;
      return jsonList.map((json) => ScheduleDto.fromJson(json)).toList();
    } catch (e) {
      // 에러 처리
      rethrow;
    }
  }
}