import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/presentation/provider/recommendation_provider.dart';
import 'package:http/http.dart' as http;

class DestinationImage extends ConsumerWidget {
  final String destination;
  static final Map<String, String> _imageCache = {};

  const DestinationImage({
    super.key,
    required this.destination,
  });

  Future<String> _getCachedImage() async {
    if (_imageCache.containsKey(destination)) {
      return _imageCache[destination]!;
    }
    final imageUrl = await _getPixabayImage();
    _imageCache[destination] = imageUrl;
    return imageUrl;
  }

  Future<String> _getPixabayImage() async {
    try {
      final city = destination.split('(')[0].trim();
      final query = Uri.encodeComponent(city);
      final response = await http.get(
        Uri.parse(
          'https://pixabay.com/api/?key=48447680-a9467e6fd874740328fcde2e3&q=$query&image_type=photo&category=travel&orientation=horizontal&per_page=3',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['hits'].isNotEmpty) {
          return data['hits'][0]['webformatURL'];
        }
      }
      throw Exception('이미지를 찾을 수 없습니다');
    } catch (e) {
      throw Exception('이미지 로드 실패: $e');
    }
  }

  Map<String, List<String>> getCityTags(
      String city, List<String> travelStyles) {
    final tags = <String, List<String>>{
      // 일본
      '도쿄': ['현대적', '쇼핑천국'],
      '오사카': ['맛집여행', '활기찬'],
      '교토': ['전통문화', '고즈넉한'],
      // ... 나머지 도시 태그들
    };

    List<String> cityTags = tags[city] ?? ['도시여행', '관광'];

    if (travelStyles.contains('맛집')) {
      cityTags = ['맛집투어', ...cityTags];
    }
    if (travelStyles.contains('쇼핑')) {
      cityTags = ['쇼핑', ...cityTags];
    }

    return {'tags': cityTags.take(2).toList()};
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: SizedBox(
              width: double.infinity,
              child: _buildCachedImage(),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: _buildDestinationTags(ref),
          ),
        ],
      ),
    );
  }

  Widget _buildCachedImage() {
    return FutureBuilder<String>(
      future: _getCachedImage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary_450),
          );
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return Container(
            color: Colors.grey[200],
            child: const Icon(Icons.error),
          );
        }
        return Image.network(
          snapshot.data!,
          fit: BoxFit.cover,
          key: ValueKey(destination),
        );
      },
    );
  }

  Widget _buildDestinationTags(WidgetRef ref) {
    final tags = getCityTags(
      destination,
      ref.read(recommendationStateProvider).travelStyles,
    )['tags']!;

    return Wrap(
      spacing: 8,
      children: tags.map((tag) => _buildTag(tag)).toList(),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }
}
