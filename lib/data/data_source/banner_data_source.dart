import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wetravel/data/dto/banner_dto.dart';

abstract class BannerDataSource {
  Future<List<BannerDto>> getBanners();
}

class BannerDataSourceImpl implements BannerDataSource {
  final Dio dio;

  BannerDataSourceImpl({required this.dio});

  @override
  Future<List<BannerDto>> getBanners() async {
    try {
      final response = await dio.get(dotenv.env['ANDROID_API_KEY']!);
      final List<dynamic> jsonList = response.data;
      return jsonList.map((json) => BannerDto.fromJson(json)).toList();
    } catch (e) {
      // 에러 처리
      rethrow;
    }
  }
}
