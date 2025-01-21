import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/domain/entity/banner_entity.dart';
import 'package:wetravel/data/repositories/banner_repository_impl.dart';

final bannerProvider = FutureProvider<List<BannerEntity>>((ref) async {
  final repository = ref.watch(bannerRepositoryProvider);
  return await repository.getBanners();
});

final bannerRepositoryProvider = Provider<BannerRepositoryImpl>((ref) => BannerRepositoryImpl(
  dio: Dio(), // Dio 인스턴스 생성
));