import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_spacing.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/domain/entity/survey_response.dart';
import 'package:wetravel/presentation/pages/guide_package/filtered_guide_package_page.dart';

class PlanSelectionPage extends ConsumerWidget {
  const PlanSelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surveyResponse =
        ModalRoute.of(context)?.settings.arguments as SurveyResponse;

    return Scaffold(
      backgroundColor: Colors.white,
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
              const LinearProgressIndicator(
                value: 3 / 4,
                backgroundColor: AppColors.grayScale_150,
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.primary_450),
              ),
              const SizedBox(height: 40),
              Text('어떤 방식으로\n여행 일정을 추천받으시겠어요?', style: AppTypography.headline2),
              const SizedBox(height: 40),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1,
                  children: [
                    _buildSelectionCard(
                      'AI',
                      '로 추천받을래요',
                      Icons.auto_awesome,
                      () {
                        Navigator.pushReplacementNamed(
                          context,
                          '/ai-recommendation',
                          arguments: surveyResponse,
                        );
                      },
                    ),
                    _buildSelectionCard(
                      '가이드',
                      '로 추천받을래요',
                      Icons.person_outline,
                      () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return FilteredGuidePackagePage();
                            },
                          ),
                          (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionCard(
      String title, String subtitle, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary_050,
          borderRadius: AppBorderRadius.small12,
        ),
        child: Padding(
          padding: AppSpacing.large20,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title,
                  style: AppTypography.headline3.copyWith(
                    color: AppColors.grayScale_750,
                  )),
              const SizedBox(height: 8),
              Text(subtitle,
                  style: AppTypography.body2.copyWith(
                    color: AppColors.grayScale_550,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
