import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/domain/entity/survey_response.dart';
import 'package:wetravel/presentation/provider/recommendation_provider.dart';

class PlanSelectionPage extends ConsumerWidget {
  const PlanSelectionPage({super.key});

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
                value: 0.75,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              const SizedBox(height: 40),
              const Text(
                '어떤 방식으로\n여행을 계획할까요?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: _buildSelectionCard(
                      'AI와 함께하기',
                      'AI가 추천하는 최적의 일정으로 여행해보세요',
                      Icons.auto_awesome,
                      () {
                        final surveyState =
                            ref.read(recommendationStateProvider);
                        final selectedCity =
                            surveyState.selectedCities.isNotEmpty
                                ? surveyState.selectedCities.first
                                : null;

                        final surveyResponse = SurveyResponse(
                          travelPeriod: surveyState.travelPeriod ?? '1개월 이내',
                          travelDuration: surveyState.travelDuration ?? '3박 4일',
                          companions: surveyState.companions.isEmpty
                              ? ['혼자']
                              : surveyState.companions,
                          travelStyles: surveyState.travelStyles.isEmpty
                              ? ['관광지', '맛집']
                              : surveyState.travelStyles,
                          accommodationTypes:
                              surveyState.accommodationTypes.isEmpty
                                  ? ['호텔']
                                  : surveyState.accommodationTypes,
                          considerations: surveyState.considerations.isEmpty
                              ? ['위치']
                              : surveyState.considerations,
                          selectedCity: selectedCity,
                        );

                        Navigator.pushReplacementNamed(
                          context,
                          '/ai-recommendation',
                          arguments: surveyResponse,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSelectionCard(
                      '가이드와 함께하기',
                      '현지 가이드의 추천 일정으로 여행해보세요',
                      Icons.person_outline,
                      () {
                        Navigator.pushReplacementNamed(
                            context, '/manual-planning');
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionCard(
      String title, String subtitle, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 32, color: Colors.blue),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
