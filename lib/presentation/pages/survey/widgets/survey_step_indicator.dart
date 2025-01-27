import 'package:flutter/material.dart';

class SurveyStepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const SurveyStepIndicator({
    super.key,
    required this.currentStep,
    this.totalSteps = 6,
  });

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: (currentStep + 1) / totalSteps,
      backgroundColor: Colors.grey[200],
      valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
    );
  }
}
