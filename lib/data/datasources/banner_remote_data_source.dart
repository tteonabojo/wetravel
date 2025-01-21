import 'package:dio/dio.dart';
import 'package:wetravel/data/dto/banner_dto.dart';

abstract class BannerRemoteDataSource {
  Future<List<Bannerdto>> getBanners();
}

class BannerRemoteDataSourceImpl implements BannerRemoteDataSource {
  final Dio dio;

  BannerRemoteDataSourceImpl({required this.dio});

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