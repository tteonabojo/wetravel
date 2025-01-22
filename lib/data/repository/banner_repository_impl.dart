import 'package:dio/dio.dart';
import 'package:wetravel/data/dto/banner_dto.dart';
import 'package:wetravel/domain/entity/banner.dart';
import 'package:wetravel/domain/repository/banner_repository.dart'; // BannerEntity 클래스 추가

class BannerRepositoryImpl implements BannerRepository {
  final Dio dio;

  BannerRepositoryImpl({required this.dio});

  @override
  Future<List<Banner>> getBanners() async {
    try {
      final response = await dio.get('/banners');
      final List<dynamic> jsonList = response.data;
      final List<BannerDto> bannerDtos =
          jsonList.map((json) => BannerDto.fromJson(json)).toList();
      return bannerDtos.map((dto) => Banner.fromDto(dto)).toList();
    } catch (e) {
      // 에러 처리 (예: 로그 출력, 사용자에게 알림)
      print('Error fetching banners: $e');
      rethrow;
    }
  }
}
