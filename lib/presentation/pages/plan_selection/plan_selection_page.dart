import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wetravel/core/constants/app_border_radius.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_spacing.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/domain/entity/survey_response.dart';
import 'package:wetravel/presentation/pages/guide_package/filtered_guide_package_page.dart';

/// 여행 계획 방식 선택 페이지
class PlanSelectionPage extends ConsumerWidget {
  const PlanSelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // null 체크 추가
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args == null) {
      print('No arguments passed to PlanSelectionPage');
      // 인자가 없을 경우 이전 페이지로 돌아가기
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

    print('PlanSelectionPage received survey response:');
    print('Travel Period: ${surveyResponse.travelPeriod}');
    print('Travel Duration: ${surveyResponse.travelDuration}');

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
                child: _buildSelectionGrid(context, surveyResponse),
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
          value: 3 / 4,
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
      BuildContext context, SurveyResponse surveyResponse) {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1,
      children: [
        _buildAIRecommendationCard(context, surveyResponse),
        _buildGuideRecommendationCard(context),
      ],
    );
  }

  /// AI 추천 카드 구성
  Widget _buildAIRecommendationCard(
      BuildContext context, SurveyResponse surveyResponse) {
    return InkWell(
      onTap: () {
        try {
          print('AI card tapped with survey response:');
          print('Travel Period: ${surveyResponse.travelPeriod}');
          print('Travel Duration: ${surveyResponse.travelDuration}');
          print('Companions: ${surveyResponse.companions}');

          Navigator.of(context)
              .pushNamed(
            '/ai-recommendation',
            arguments: surveyResponse,
          )
              .then((_) {
            print('Navigation completed');
          }).catchError((error) {
            print('Navigation error: $error');
          });
        } catch (e, stack) {
          print('Error in AI card tap: $e');
          print('Stack trace: $stack');
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
          Navigator.of(context).pushNamed('/manual-planning');
        } catch (e) {
          print('Error in guide card tap: $e');
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
