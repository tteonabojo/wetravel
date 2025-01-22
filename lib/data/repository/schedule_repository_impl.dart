import 'package:dio/dio.dart';
import 'package:wetravel/data/dto/schedule_dto.dart';
import 'package:wetravel/domain/entity/schedule.dart';
import 'package:wetravel/domain/repository/schedule_repository.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final Dio dio;

  ScheduleRepositoryImpl({required this.dio});

  @override
  Future<List<Schedule>> getSchedules() async {
    try {
      final response = await dio.get('/schedules');
      final List<dynamic> jsonList = response.data;
      final List<ScheduleDto> scheduleDtos =
          jsonList.map((json) => ScheduleDto.fromJson(json)).toList();
      return scheduleDtos.map((dto) => Schedule.fromDto(dto)).toList();
    } catch (e) {
      // 에러 처리
      print('Error fetching schedules: $e');
      rethrow;
    }
  }
}
