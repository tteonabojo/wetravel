import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/presentation/widgets/buttons/standard_button.dart';

class OnBoardingScreen extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final bool isLastPage;
  final PageController controller;

  const OnBoardingScreen({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.isLastPage,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final String buttonStr = isLastPage != true ? '다음으로' : '시작하기';

    /// 메인 페이지로 이동
    void skip() {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }

    /// 다음 페이지로 이동
    void next() {
      if (isLastPage != true) {
        controller.nextPage(
            duration: Duration(microseconds: 300), curve: Curves.easeIn);
      } else {
        skip();
      }
    }

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final topImageMargin = screenHeight * 0.45 - 350;
    final bottomPadding = screenHeight * 0.05;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 50, 16, 30),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(right: screenWidth * 0.025),
            child: Container(
              height: 56,
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => skip(),
                child: isLastPage != true
                    ? Text(
                        '건너뛰기',
                        style: AppTypography.body2.copyWith(
                          color: AppColors.primary_450,
                        ),
                      )
                    : SizedBox(),
              ),
            ),
          ),
          SizedBox(height: topImageMargin), // 이미지 위 여백
          Image.asset(image),
          SizedBox(height: 20), // 이미지와 텍스트 간 여백
          SmoothPageIndicator(
            controller: controller,
            count: 3,
            effect: ExpandingDotsEffect(
              activeDotColor: AppColors.grayScale_950,
              dotColor: AppColors.grayScale_250,
              dotHeight: 4,
              dotWidth: 4,
              expansionFactor: 3,
              spacing: 8,
            ),
          ),
          SizedBox(height: bottomPadding), // 텍스트 아래 여백
          Text(
            title,
            style: AppTypography.headline3.copyWith(
              color: AppColors.grayScale_950,
            ),
          ),
          SizedBox(height: 12),
          Text(
            description,
            style: AppTypography.body2.copyWith(
              color: AppColors.grayScale_550,
            ),
            textAlign: TextAlign.center,
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(bottom: screenHeight * 0.015),
            child: StandardButton.primary(
              sizeType: ButtonSizeType.normal,
              text: buttonStr,
              onPressed: () {
                next();
              },
            ),
          )
        ],
      ),
    );
  }
}
