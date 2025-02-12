import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/data/data_source/banner_data_source.dart';
import 'package:wetravel/data/data_source/data_source_implement/banner_data_source_impl.dart';
import 'package:wetravel/data/repository/banner_repository_impl.dart';
import 'package:wetravel/domain/repository/banner_repository.dart';
import 'package:wetravel/domain/usecase/fetch_banners_usecase.dart';

final _bannerDataSourceProvider = Provider<BannerDataSource>((ref) {
  return BannerDataSourceImpl(FirebaseFirestore.instance);
});

final _bannerRepositoryProvider = Provider<BannerRepository>(
  (ref) {
    final dataSource = ref.read(_bannerDataSourceProvider);
    return BannerRepositoryImpl(dataSource);
  },
);

final fetchBannersUsecaseProvider = Provider(
  (ref) {
    final bannerRepo = ref.read(_bannerRepositoryProvider);
    return FetchBannersUsecase(bannerRepo);
  },
);
