import 'package:dio/dio.dart';
import 'package:wetravel/data/dto/banner_dto.dart';

abstract class BannerDataSource {
  Future<List<Bannerdto>> getBanners();
}

class BannerDataSourceImpl implements BannerDataSource {
  final Dio dio;

  BannerDataSourceImpl({required this.dio});

  @override
  Future<List<Bannerdto>> getBanners() async {
    try {
      final response = await dio.get('AIzaSyD9FXUs9pi8RkbNx5smRb3ozstlyv5bVIE');
      final List<dynamic> jsonList = response.data;
      return jsonList.map((json) => Bannerdto.fromJson(json)).toList();
    } catch (e) {
      // 에러 처리
      rethrow;
    }
  }
}
