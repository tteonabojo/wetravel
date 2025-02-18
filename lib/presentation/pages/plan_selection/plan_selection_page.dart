import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_spacing.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/domain/entity/survey_response.dart';
import 'package:wetravel/presentation/pages/guide_package/filtered_guide_package_page.dart';
import 'package:wetravel/presentation/provider/survey_provider.dart';
import 'package:wetravel/presentation/provider/recommendation_provider.dart';

/// 여행 계획 방식 선택 페이지
class PlanSelectionPage extends ConsumerWidget {
  const PlanSelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
      });
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final surveyResponse = args as SurveyResponse;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 40),
              Expanded(
                child: _buildSelectionGrid(context, surveyResponse, ref),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 헤더 영역 구성
  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        const SizedBox(height: 20),
        const LinearProgressIndicator(
          value: 5 / 6,
          backgroundColor: AppColors.grayScale_150,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary_450),
        ),
        const SizedBox(height: 40),
        Text('어떤 방식으로\n여행 일정을 추천받으시겠어요?', style: AppTypography.headline2),
      ],
    );
  }

  /// 선택 그리드 구성
  Widget _buildSelectionGrid(
      BuildContext context, SurveyResponse surveyResponse, WidgetRef ref) {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1,
      children: [
        _buildAIRecommendationCard(context, surveyResponse, ref),
        _buildGuideRecommendationCard(context),
      ],
    );
  }

  /// AI 추천 카드 구성
  Widget _buildAIRecommendationCard(
      BuildContext context, SurveyResponse surveyResponse, WidgetRef ref) {
    return InkWell(
      onTap: () {
        try {
          if (ModalRoute.of(context)?.settings.arguments == null) {
            ref.read(surveyProvider.notifier).resetState();
          }

          ref.read(recommendationStateProvider.notifier).resetState();
          ref.invalidate(recommendationProvider);

          Navigator.of(context).pushNamed(
            '/ai-recommendation',
            arguments: surveyResponse,
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('오류가 발생했습니다: $e')),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary_050,
          borderRadius: AppBorderRadius.small12,
        ),
        child: _buildCardContent('AI', '로 추천받을래요'),
      ),
    );
  }

  /// 가이드 추천 카드 구성
  Widget _buildGuideRecommendationCard(BuildContext context) {
    return InkWell(
      onTap: () {
        try {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => FilteredGuidePackagePage(),
            ),
            (route) => false,
          );
        } catch (e) {
          log('Error in guide card tap: $e');
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary_050,
          borderRadius: AppBorderRadius.small12,
        ),
        child: _buildCardContent('가이드', '로 추천받을래요'),
      ),
    );
  }

  /// 카드 내용 구성
  Widget _buildCardContent(String title, String subtitle) {
    return Padding(
      padding: AppSpacing.large20,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: AppTypography.headline3.copyWith(
              color: AppColors.grayScale_750,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: AppTypography.body2.copyWith(
              color: AppColors.grayScale_550,
            ),
          ),
        ],
      ),
    );
  }
}
