import 'package:flutter/material.dart';
import 'package:wetravel/core/constants/app_colors.dart';

class SurveyStepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const SurveyStepIndicator({
    super.key,
    required this.currentStep,
    this.totalSteps = 5,
  });

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: (currentStep + 1) / totalSteps,
      backgroundColor: AppColors.grayScale_150,
      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary_450),
    );
  }
}
