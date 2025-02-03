import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/presentation/provider/recommendation_provider.dart';

class CitySelectionPage extends ConsumerWidget {
  const CitySelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 20),
              LinearProgressIndicator(
                value: 0.25,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              const SizedBox(height: 30),
              const Text(
                '떠나고 싶은\n도시를 선택해주세요',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'AI 맞춤 추천',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/survey');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.auto_awesome,
                                  color: Colors.blue[700], size: 16),
                              const SizedBox(width: 4),
                              Text(
                                'AI로 도시 추천 받을래요',
                                style: TextStyle(
                                  color: Colors.blue[700],
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        '일본',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildCityChip('도쿄', ref),
                          _buildCityChip('후쿠오카', ref),
                          _buildCityChip('시즈오카', ref),
                          _buildCityChip('오사카', ref),
                          _buildCityChip('나고야', ref),
                          _buildCityChip('삿포로', ref),
                          _buildCityChip('오키나와', ref),
                        ],
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        '일본',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildCityChip('도쿄', ref),
                          _buildCityChip('후쿠오카', ref),
                          _buildCityChip('시즈오카', ref),
                          _buildCityChip('오사카', ref),
                          _buildCityChip('나고야', ref),
                          _buildCityChip('삿포로', ref),
                          _buildCityChip('오키나와', ref),
                        ],
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        '일본',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildCityChip('도쿄', ref),
                          _buildCityChip('후쿠오카', ref),
                          _buildCityChip('시즈오카', ref),
                          _buildCityChip('오사카', ref),
                          _buildCityChip('나고야', ref),
                          _buildCityChip('삿포로', ref),
                          _buildCityChip('오키나와', ref),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (ref
                        .read(recommendationStateProvider)
                        .selectedCities
                        .isNotEmpty) {
                      Navigator.pushNamed(context, '/survey');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    '다음으로',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCityChip(String city, WidgetRef ref) {
    final isSelected =
        ref.watch(recommendationStateProvider).selectedCities.contains(city);

    return FilterChip(
      label: Text(city),
      selected: isSelected,
      onSelected: (selected) {
        ref.read(recommendationStateProvider.notifier).toggleCity(city);
      },
      backgroundColor: Colors.grey[200],
      selectedColor: Colors.grey[600],
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
      ),
    );
  }
}
