import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:wetravel/data/dto/schedule_dto.dart';
import 'package:wetravel/domain/entity/schedule_entity.dart';
import 'package:wetravel/domain/repository/schedule_repository.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final Dio dio;

  ScheduleRepositoryImpl({required this.dio});

  @override
  Future<List<ScheduleEntity>> getSchedules() async {
    try {
      final response = await dio.get('/schedules');
      final List<dynamic> jsonList = response.data;
      final List<Scheduledto> scheduleDtos = jsonList.map((json) => Scheduledto.fromJson(json)).toList();
      return scheduleDtos.map((dto) => ScheduleEntity.fromDto(dto)).toList();
    } catch (e) {
      // 에러 처리
      print('Error fetching schedules: $e');
      rethrow;
    }
  }
}