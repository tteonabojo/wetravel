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
                '어떤 방식으로\n여행 일정을 추천받으시겠어요?',
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
                      'AI',
                      '로 추천받을래요',
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
                      '가이드',
                      '로 추천받을래요',
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
      String title, String subtitle, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 160,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
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
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
